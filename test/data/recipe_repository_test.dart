import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/data/recipe_repository.dart';

void main() {
  group('RecipeRepository', () {
    const repository = RecipeRepository();

    test('getInitialRecipes retourne une liste non vide', () {
      final recipes = repository.getInitialRecipes();
      expect(recipes, isNotEmpty);
    });

    test('getInitialRecipes retourne des recettes avec des id uniques', () {
      final recipes = repository.getInitialRecipes();
      final ids = recipes.map((r) => r.id).toSet();
      expect(ids.length, recipes.length);
    });

    test('getCategories inclut "Tous" et au moins 3 catégories métier', () {
      final categories = repository.getCategories();
      expect(categories, contains('Tous'));
      expect(categories.length, greaterThanOrEqualTo(4));
    });
  });
}
