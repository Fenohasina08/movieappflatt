import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../screens/detail_screen.dart';
import '../screens/form_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

/// Configuration centralisée de la navigation avec GoRouter et routes nommées.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        name: 'recipeDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final recipe = state.extra is Recipe ? state.extra as Recipe : null;
          return DetailScreen(recipeId: id, recipeFromExtra: recipe);
        },
      ),
      GoRoute(
        path: '/add',
        name: 'addRecipe',
        builder: (context, state) => const FormScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
