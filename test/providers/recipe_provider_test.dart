import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/data/recipe_repository.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipe_provider.dart';

/// Faux repository utilisé uniquement pour les tests : simule un échec de
/// chargement des données pour vérifier que le provider gère l'erreur
/// proprement au lieu de planter.
class _ThrowingRecipeRepository extends RecipeRepository {
  const _ThrowingRecipeRepository();

  @override
  List<Recipe> getInitialRecipes() {
    throw const RecipeRepositoryException('Source de données indisponible');
  }
}

const _testRecipe = Recipe(
  id: 'test-1',
  title: 'Recette de test',
  category: 'Plat',
  prepTimeMinutes: 10,
  difficulty: 'Facile',
  description: 'Une recette utilisée uniquement pour les tests.',
  emoji: '🧪',
  ingredients: ['Ingrédient A'],
);

void main() {
  group('RecipeProvider - chargement initial', () {
    test('charge les recettes du repository par défaut sans erreur', () {
      final provider = RecipeProvider();
      expect(provider.allRecipes, isNotEmpty);
      expect(provider.errorMessage, isNull);
    });

    test('expose un message d\'erreur si le repository échoue, sans planter',
        () {
      final provider =
          RecipeProvider(repository: const _ThrowingRecipeRepository());
      expect(provider.allRecipes, isEmpty);
      expect(provider.errorMessage, isNotNull);
    });
  });

  group('RecipeProvider - recherche et filtre', () {
    late RecipeProvider provider;

    setUp(() {
      provider = RecipeProvider();
    });

    test('filteredRecipes retourne tout par défaut', () {
      expect(provider.filteredRecipes.length, provider.allRecipes.length);
    });

    test('la recherche filtre par titre, insensible à la casse', () {
      provider.updateSearchQuery('CITRON');
      expect(provider.filteredRecipes, hasLength(1));
      expect(
        provider.filteredRecipes.first.title.toLowerCase(),
        contains('citron'),
      );
    });

    test('une recherche sans résultat retourne une liste vide', () {
      provider.updateSearchQuery('inexistant-xyz');
      expect(provider.filteredRecipes, isEmpty);
    });

    test('le filtre par catégorie fonctionne', () {
      provider.updateCategory('Dessert');
      expect(
        provider.filteredRecipes.every((r) => r.category == 'Dessert'),
        isTrue,
      );
    });

    test('recherche et catégorie se combinent (ET logique)', () {
      provider.updateCategory('Dessert');
      provider.updateSearchQuery('brownie');
      expect(provider.filteredRecipes, hasLength(1));
      expect(provider.filteredRecipes.first.category, 'Dessert');
    });
  });

  group('RecipeProvider - getById', () {
    test('retourne la recette correspondante', () {
      final provider = RecipeProvider();
      final first = provider.allRecipes.first;
      expect(provider.getById(first.id), equals(first));
    });

    test('retourne null si aucun id ne correspond', () {
      final provider = RecipeProvider();
      expect(provider.getById('id-inconnu'), isNull);
    });
  });

  group('RecipeProvider - addRecipe', () {
    test('ajoute une recette valide et retourne true', () {
      final provider = RecipeProvider();
      final countBefore = provider.allRecipes.length;

      final added = provider.addRecipe(_testRecipe);

      expect(added, isTrue);
      expect(provider.allRecipes.length, countBefore + 1);
      expect(provider.getById('test-1'), isNotNull);
    });

    test('refuse une recette avec un titre vide et retourne false', () {
      final provider = RecipeProvider();
      final countBefore = provider.allRecipes.length;

      final added = provider.addRecipe(_testRecipe.copyWith(title: '   '));

      expect(added, isFalse);
      expect(provider.allRecipes.length, countBefore);
    });

    test('refuse une recette avec un temps de préparation invalide', () {
      final provider = RecipeProvider();
      final countBefore = provider.allRecipes.length;

      final added = provider.addRecipe(
        _testRecipe.copyWith(prepTimeMinutes: 0),
      );

      expect(added, isFalse);
      expect(provider.allRecipes.length, countBefore);
    });
  });
}
