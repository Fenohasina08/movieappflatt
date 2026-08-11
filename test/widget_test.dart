import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/main.dart';

void main() {
  testWidgets(
      'RecipeApp démarre sur HomeScreen et affiche une recette initiale',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    await tester.pumpAndSettle();

    expect(find.text('Mes recettes'), findsOneWidget);
    expect(find.textContaining('Poulet au coco'), findsOneWidget);
  });

  testWidgets('Le bouton Ajouter ouvre le formulaire de nouvelle recette',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle recette'), findsOneWidget);
  });

  testWidgets("L'icône paramètres ouvre l'écran des paramètres",
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Mode sombre'), findsOneWidget);
  });
}
