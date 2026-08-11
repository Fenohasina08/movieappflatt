import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/providers/theme_provider.dart';
import 'package:recipe_app/main.dart';

void main() {
  testWidgets('HomeScreen affiche le titre et au moins une recette',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    await tester.pumpAndSettle();

    expect(find.text('Mes recettes'), findsOneWidget);
    // Au moins une recette de la donnée initiale doit être visible.
    expect(find.textContaining('Poulet au coco'), findsOneWidget);
  });

  test('RecipeProvider filtre correctement par recherche', () {
    final provider = RecipeProvider();
    provider.updateSearchQuery('citron');
    expect(provider.filteredRecipes.length, 1);
    expect(provider.filteredRecipes.first.title, contains('citron'));
  });

  test('ThemeProvider bascule correctement le thème', () {
    final provider = ThemeProvider();
    expect(provider.isDarkMode, false);
    provider.toggleTheme(true);
    expect(provider.isDarkMode, true);
  });
}
