import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/form_screen.dart';

void main() {
  // FormScreen utilise `context.pop()` de go_router : on encapsule donc les
  // tests dans un vrai GoRouter à deux routes (accueil factice + formulaire)
  // plutôt qu'un simple MaterialApp, pour que la navigation reste fidèle au
  // comportement réel de l'app. On démarre sur l'accueil puis on pousse
  // vers le formulaire, afin que la pile de navigation contienne bien deux
  // pages et que `pop()` ait un écran vers lequel revenir.
  Widget wrap(RecipeProvider provider) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.push('/form'),
                child: const Text('Ouvrir le formulaire'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/form',
          builder: (context, state) => const FormScreen(),
        ),
      ],
    );

    return ChangeNotifierProvider<RecipeProvider>.value(
      value: provider,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  Future<void> openForm(WidgetTester tester) async {
    await tester.tap(find.text('Ouvrir le formulaire'));
    await tester.pumpAndSettle();
  }

  testWidgets('affiche les erreurs de validation si le formulaire est vide',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(RecipeProvider()));
    await openForm(tester);

    await tester.tap(find.text('Enregistrer la recette'));
    await tester.pumpAndSettle();

    expect(find.text('Le titre est obligatoire'), findsOneWidget);
    expect(
      find.text('Le temps de préparation est obligatoire'),
      findsOneWidget,
    );
    expect(find.text('La description est obligatoire'), findsOneWidget);
  });

  testWidgets('refuse un titre trop court', (WidgetTester tester) async {
    await tester.pumpWidget(wrap(RecipeProvider()));
    await openForm(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Titre *'), 'A');
    await tester.tap(find.text('Enregistrer la recette'));
    await tester.pumpAndSettle();

    expect(
      find.text('Le titre doit contenir au moins 3 caractères'),
      findsOneWidget,
    );
  });

  testWidgets(
      'ajoute une recette au provider quand tous les champs sont valides',
      (WidgetTester tester) async {
    final provider = RecipeProvider();
    final countBefore = provider.allRecipes.length;

    await tester.pumpWidget(wrap(provider));
    await openForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre *'),
      'Nouvelle recette de test',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Temps de préparation (minutes) *'),
      '20',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description *'),
      'Une description suffisamment longue pour être valide.',
    );

    await tester.tap(find.text('Enregistrer la recette'));
    await tester.pumpAndSettle();

    expect(provider.allRecipes.length, countBefore + 1);
    expect(find.text('Recette ajoutée avec succès !'), findsOneWidget);
  });
}
