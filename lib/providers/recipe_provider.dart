import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';

/// Gère l'état de la liste de recettes : données, recherche et filtre.
///
/// Toute la logique de filtrage vit ici, pas dans les widgets, afin de
/// garder l'UI "bête" et réutilisable.
class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _recipes = RecipeRepository.getInitialRecipes();

  String _searchQuery = '';
  String _selectedCategory = 'Tous';

  List<Recipe> get allRecipes => List.unmodifiable(_recipes);

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => RecipeRepository.getCategories();

  List<Recipe> get filteredRecipes {
    return _recipes.where((recipe) {
      final matchesCategory =
          _selectedCategory == 'Tous' || recipe.category == _selectedCategory;
      final matchesSearch = recipe.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Recipe? getById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }
}
