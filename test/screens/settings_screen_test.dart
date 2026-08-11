import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/theme_provider.dart';
import 'package:recipe_app/screens/settings_screen.dart';

void main() {
  Widget wrap(ThemeProvider provider) {
    return ChangeNotifierProvider<ThemeProvider>.value(
      value: provider,
      child: const MaterialApp(home: SettingsScreen()),
    );
  }

  testWidgets('affiche le switch de thème désactivé en mode clair',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(ThemeProvider()));

    final switchTile =
        tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(switchTile.value, isFalse);
    expect(find.text('Mode sombre'), findsOneWidget);
  });

  testWidgets('basculer le switch appelle toggleTheme et met à jour l\'état',
      (WidgetTester tester) async {
    final provider = ThemeProvider();
    await tester.pumpWidget(wrap(provider));

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(provider.isDarkMode, isTrue);

    final switchTile =
        tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(switchTile.value, isTrue);
  });
}
