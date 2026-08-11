import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/providers/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    test('démarre en mode clair par défaut', () {
      final provider = ThemeProvider();
      expect(provider.isDarkMode, isFalse);
      expect(provider.themeMode, ThemeMode.light);
    });

    test('toggleTheme(true) passe en mode sombre', () {
      final provider = ThemeProvider();
      provider.toggleTheme(true);
      expect(provider.isDarkMode, isTrue);
      expect(provider.themeMode, ThemeMode.dark);
    });

    test('toggleTheme(false) revient en mode clair', () {
      final provider = ThemeProvider();
      provider.toggleTheme(true);
      provider.toggleTheme(false);
      expect(provider.isDarkMode, isFalse);
      expect(provider.themeMode, ThemeMode.light);
    });

    test('notifie ses auditeurs lors du changement de thème', () {
      final provider = ThemeProvider();
      var notified = false;
      provider.addListener(() => notified = true);

      provider.toggleTheme(true);

      expect(notified, isTrue);
    });
  });
}
