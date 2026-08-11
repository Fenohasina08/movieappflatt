import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/detail_screen.dart';

const _extraRecipe = Recipe(
  id: 'extra-1',
  title: 'Recette via extra',
  category: 'Plat',
  prepTimeMinutes: 12,
  difficulty: 'Facile',
  description: 'Recette passée via le paramètre extra de la route.',
  emoji: '🍝',
  ingredients: ['X'],
);

void main() {
  Widget wrap(RecipeProvider provider, Widget child) {
    return ChangeNotifierProvider<RecipeProvider>.value(
      value: provider,
      child: MaterialApp(home: child),
    );
  }

  testWidgets('affiche la recette fournie via recipeFromExtra',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        RecipeProvider(),
        const DetailScreen(
          recipeId: 'extra-1',
          recipeFromExtra: _extraRecipe,
        ),
      ),
    );

    expect(find.text('Description'), findsOneWidget);
    expect(
      find.text('Recette passée via le paramètre extra de la route.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'retrouve la recette via le provider quand recipeFromExtra est null '
      '(ex: deep link)', (WidgetTester tester) async {
    final provider = RecipeProvider();
    final knownRecipe = provider.allRecipes.first;

    await tester.pumpWidget(
      wrap(provider, DetailScreen(recipeId: knownRecipe.id)),
    );

    expect(find.text(knownRecipe.description), findsOneWidget);
  });

  testWidgets(
      "ignore recipeFromExtra si son id ne correspond pas à recipeId, et "
      're-cherche via le provider', (WidgetTester tester) async {
    final provider = RecipeProvider();
    final knownRecipe = provider.allRecipes.first;

    // recipeId pointe vers une vraie recette du provider, mais l'objet
    // "extra" fourni a un id différent : le garde-fou de DetailScreen doit
    // ignorer cet extra incohérent plutôt que d'afficher la mauvaise
    // recette.
    await tester.pumpWidget(
      wrap(
        provider,
        DetailScreen(
          recipeId: knownRecipe.id,
          recipeFromExtra: _extraRecipe,
        ),
      ),
    );

    expect(find.text(knownRecipe.description), findsOneWidget);
    expect(find.text(_extraRecipe.description), findsNothing);
  });

  testWidgets("affiche un message si la recette n'existe pas",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(RecipeProvider(), const DetailScreen(recipeId: 'id-inconnu')),
    );

    expect(find.text('Recette introuvable'), findsOneWidget);
    expect(find.text('Cette recette n\'existe pas.'), findsOneWidget);
  });
}
