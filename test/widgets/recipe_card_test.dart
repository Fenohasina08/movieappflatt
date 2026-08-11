import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/widgets/recipe_card.dart';

const _recipe = Recipe(
  id: 'r1',
  title: 'Recette Test',
  category: 'Plat',
  prepTimeMinutes: 25,
  difficulty: 'Facile',
  description: 'Description de test.',
  emoji: '🍲',
  ingredients: ['A', 'B'],
);

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('affiche le titre, la catégorie et le temps de préparation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(RecipeCard(recipe: _recipe, onTap: () {})),
    );

    expect(find.text('Recette Test'), findsOneWidget);
    expect(find.text('Plat'), findsOneWidget);
    expect(find.text('25 min'), findsOneWidget);
  });

  testWidgets('déclenche onTap au tap', (WidgetTester tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(RecipeCard(recipe: _recipe, onTap: () => tapped = true)),
    );

    await tester.tap(find.byType(RecipeCard));
    expect(tapped, isTrue);
  });
}
