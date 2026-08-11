import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

/// Écran 3 : formulaire d'ajout de recette avec validation.
///
/// Contient 4 champs validés : titre, catégorie, temps de préparation,
/// description (au moins 3 requis par le sujet).
class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();

  String _category = 'Plat';
  String _difficulty = 'Facile';

  @override
  void dispose() {
    _titleController.dispose();
    _prepTimeController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le titre est obligatoire';
    }
    if (value.trim().length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    return null;
  }

  String? _validatePrepTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le temps de préparation est obligatoire';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return 'Entrez un nombre de minutes valide (> 0)';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La description est obligatoire';
    }
    if (value.trim().length < 10) {
      return 'Décrivez la recette en au moins 10 caractères';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final recipeProvider = context.read<RecipeProvider>();
    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final newRecipe = Recipe(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      category: _category,
      prepTimeMinutes: int.parse(_prepTimeController.text.trim()),
      difficulty: _difficulty,
      description: _descriptionController.text.trim(),
      emoji: '🍽️',
      ingredients: ingredients.isEmpty ? ['Non renseigné'] : ingredients,
    );

    final added = recipeProvider.addRecipe(newRecipe);

    if (!added) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impossible d'ajouter cette recette : données invalides.",
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recette ajoutée avec succès !')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final providerCategories = context
        .watch<RecipeProvider>()
        .categories
        .where((c) => c != 'Tous')
        .toList();
    // Repli défensif : si la source de catégories est vide (cas d'erreur
    // improbable géré par le provider), on garde au moins une option pour
    // que le DropdownButtonFormField reste utilisable.
    final categories =
        providerCategories.isEmpty ? const ['Plat'] : providerCategories;
    if (!categories.contains(_category)) {
      _category = categories.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle recette')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre *',
                border: OutlineInputBorder(),
              ),
              validator: _validateTitle,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Catégorie *',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prepTimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Temps de préparation (minutes) *',
                border: OutlineInputBorder(),
              ),
              validator: _validatePrepTime,
            ),
            const SizedBox(height: 16),
            Text('Difficulté', style: Theme.of(context).textTheme.titleSmall),
            Wrap(
              spacing: 8,
              children: ['Facile', 'Moyen', 'Difficile'].map((level) {
                return ChoiceChip(
                  label: Text(level),
                  selected: _difficulty == level,
                  onSelected: (_) => setState(() => _difficulty = level),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
              ),
              validator: _validateDescription,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingrédients (séparés par des virgules)',
                border: OutlineInputBorder(),
                hintText: 'Ex: Farine, Beurre, Sucre',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Enregistrer la recette'),
            ),
          ],
        ),
      ),
    );
  }
}
