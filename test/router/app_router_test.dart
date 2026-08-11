import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/providers/theme_provider.dart';
import 'package:recipe_app/router/app_router.dart';
import 'package:recipe_app/screens/detail_screen.dart';
import 'package:recipe_app/screens/form_screen.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/settings_screen.dart';

void main() {
  Widget wrap() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: MaterialApp.router(routerConfig: AppRouter.router),
    );
  }

  testWidgets('la route "/" affiche HomeScreen', (WidgetTester tester) async {
    AppRouter.router.go('/');
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('la route "/add" affiche FormScreen',
      (WidgetTester tester) async {
    AppRouter.router.go('/add');
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byType(FormScreen), findsOneWidget);
  });

  testWidgets('la route "/settings" affiche SettingsScreen',
      (WidgetTester tester) async {
    AppRouter.router.go('/settings');
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('la route "/recipe/:id" affiche DetailScreen avec le bon id',
      (WidgetTester tester) async {
    AppRouter.router.go('/recipe/r1');
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final detailScreen = tester.widget<DetailScreen>(
      find.byType(DetailScreen),
    );
    expect(detailScreen.recipeId, 'r1');
  });
}
