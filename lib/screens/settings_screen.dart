import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Écran 4 : paramètres, avec la gestion du thème clair / sombre.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode_outlined,
            ),
            title: const Text('Mode sombre'),
            subtitle: const Text('Basculer entre thème clair et sombre'),
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleTheme,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('À propos'),
            subtitle: Text('App de recettes — projet Flutter pédagogique.'),
          ),
        ],
      ),
    );
  }
}
