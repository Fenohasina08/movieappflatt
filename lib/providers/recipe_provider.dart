import 'package:flutter/foundation.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';

/// Gère l'état de la liste de recettes : données, recherche et filtre.
///
/// Toute la logique de filtrage vit ici, pas dans les widgets, afin de
/// garder l'UI "bête" et réutilisable.
///
/// Le repository est injecté via le constructeur (avec une implémentation
/// par défaut) plutôt qu'instancié en dur : cela permet de fournir un
/// faux repository dans les tests pour simuler des cas d'erreur ou des
/// jeux de données spécifiques, sans dépendre des vraies données.
class RecipeProvider extends ChangeNotifier {
  RecipeProvider({RecipeRepository? repository})
    : _repository = repository ?? const RecipeRepository() {
    _loadInitialRecipes();
  }

  final RecipeRepository _repository;

  final List<Recipe> _recipes = [];

  String _searchQuery = '';
  String _selectedCategory = 'Tous';

  /// Message d'erreur à afficher dans l'UI si le chargement des données
  /// a échoué. `null` si tout va bien.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Charge les recettes initiales depuis le repository. En cas d'échec
  /// (ex: source de données corrompue ou indisponible), l'app ne plante
  /// pas : elle démarre avec une liste vide et expose un message d'erreur
  /// que l'UI peut afficher, plutôt que de crasher silencieusement.
  void _loadInitialRecipes() {
    try {
      final initial = _repository.getInitialRecipes();
      _recipes.addAll(initial);
      _errorMessage = null;
    } on RecipeRepositoryException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Une erreur inattendue est survenue au chargement '
          'des recettes.';
    }
  }

  List<Recipe> get allRecipes => List.unmodifiable(_recipes);

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    try {
      return _repository.getCategories();
    } catch (_) {
      // Repli sûr : si la source de catégories est indisponible, on
      // garde au minimum le filtre "Tous" pour ne pas casser l'UI.
      return const ['Tous'];
    }
  }

  List<Recipe> get filteredRecipes {
    final query = _searchQuery.trim().toLowerCase();
    return _recipes.where((recipe) {
      final matchesCategory =
          _selectedCategory == 'Tous' || recipe.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          recipe.title.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Recipe? getById(String id) {
    for (final recipe in _recipes) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Ajoute une recette après une validation défensive minimale : même si
  /// le formulaire valide déjà ses champs, le provider ne fait pas
  /// confiance aveuglément à l'appelant et refuse une recette manifestement
  /// invalide (titre vide ou temps de préparation négatif/nul), ce qui
  /// évite de corrompre l'état de l'app si `addRecipe` est un jour appelé
  /// depuis un autre endroit que le formulaire.
  ///
  /// Cette méthode est aussi entourée d'un `try/catch` : aujourd'hui,
  /// `_recipes.add` sur une simple `List` en mémoire ne peut pas échouer,
  /// mais si le repository évolue vers une vraie persistance (API,
  /// base de données locale...), une écriture pourra lever une exception
  /// (ex: réseau indisponible). Le `try/catch` est prêt pour ce cas :
  /// l'échec est capturé, exposé via [errorMessage], et l'app ne plante
  /// pas au lieu de propager une exception non gérée jusqu'à l'UI.
  bool addRecipe(Recipe recipe) {
    if (recipe.title.trim().isEmpty || recipe.prepTimeMinutes <= 0) {
      return false;
    }
    try {
      _recipes.add(recipe);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Impossible d'ajouter la recette : $e";
      notifyListeners();
      return false;
    }
  }
}
