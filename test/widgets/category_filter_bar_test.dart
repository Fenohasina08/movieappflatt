import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/widgets/category_filter_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('affiche toutes les catégories et marque la sélection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        CategoryFilterBar(
          categories: const ['Tous', 'Entrée', 'Plat', 'Dessert'],
          selectedCategory: 'Plat',
          onSelected: (_) {},
        ),
      ),
    );

    expect(find.text('Tous'), findsOneWidget);
    expect(find.text('Entrée'), findsOneWidget);
    expect(find.text('Plat'), findsOneWidget);
    expect(find.text('Dessert'), findsOneWidget);

    final selectedChip = tester.widget<ChoiceChip>(
      find.ancestor(
        of: find.text('Plat'),
        matching: find.byType(ChoiceChip),
      ),
    );
    expect(selectedChip.selected, isTrue);
  });

  testWidgets('appelle onSelected avec la catégorie tapée',
      (WidgetTester tester) async {
    String? selected;
    await tester.pumpWidget(
      wrap(
        CategoryFilterBar(
          categories: const ['Tous', 'Dessert'],
          selectedCategory: 'Tous',
          onSelected: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('Dessert'));
    await tester.pumpAndSettle();

    expect(selected, 'Dessert');
  });
}
