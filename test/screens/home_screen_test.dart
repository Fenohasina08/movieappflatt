import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/data/recipe_repository.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/widgets/recipe_grid.dart';

class _ThrowingRecipeRepository extends RecipeRepository {
  const _ThrowingRecipeRepository();

  @override
  List<Recipe> getInitialRecipes() {
    throw const RecipeRepositoryException('Panne simulée');
  }
}

void main() {
  // HomeScreen navigue avec go_router (recherche de détail, paramètres,
  // ajout) : on l'enveloppe donc dans un GoRouter minimal plutôt qu'un
  // simple MaterialApp.
  Widget wrap(RecipeProvider provider) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) =>
              const Scaffold(body: Text('Détail (placeholder de test)')),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) =>
              const Scaffold(body: Text('Formulaire (placeholder de test)')),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) =>
              const Scaffold(body: Text('Paramètres (placeholder de test)')),
        ),
      ],
    );

    return ChangeNotifierProvider<RecipeProvider>.value(
      value: provider,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('affiche la liste des recettes et le champ de recherche',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(RecipeProvider()));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.textContaining('Poulet au coco'), findsOneWidget);
  });

  testWidgets('la recherche met à jour la liste affichée en temps réel',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(RecipeProvider()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'citron');
    await tester.pumpAndSettle();

    expect(find.textContaining('Tarte au citron'), findsOneWidget);
    expect(find.textContaining('Poulet au coco'), findsNothing);
  });

  testWidgets("affiche l'état vide si aucune recette ne correspond",
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(RecipeProvider()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'introuvable-xyz');
    await tester.pumpAndSettle();

    expect(find.text('Aucune recette trouvée'), findsOneWidget);
  });

  testWidgets('utilise une grille responsive sur un écran large (tablette)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(RecipeProvider()));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeGrid), findsOneWidget);
  });

  testWidgets('affiche une bannière si le chargement des recettes échoue',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(RecipeProvider(repository: const _ThrowingRecipeRepository())),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Panne simulée'), findsOneWidget);
  });
}
