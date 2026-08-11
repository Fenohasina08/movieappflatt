import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

/// Écran 2 : détail d'une recette.
///
/// Démontre le passage de paramètres via la navigation :
/// - [recipeId] vient du segment d'URL /recipe/:id
/// - [recipeFromExtra] vient de l'objet "extra" passé lors du push,
///   utilisé en priorité pour éviter une recherche ; sinon on retrouve
///   la recette via le Provider grâce à l'id (utile si on arrive par un
///   lien direct, ex: deep link).
class DetailScreen extends StatelessWidget {
  final String recipeId;
  final Recipe? recipeFromExtra;

  const DetailScreen({
    super.key,
    required this.recipeId,
    this.recipeFromExtra,
  });

  @override
  Widget build(BuildContext context) {
    final recipe =
        recipeFromExtra ?? context.watch<RecipeProvider>().getById(recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recette introuvable')),
        body: const Center(child: Text('Cette recette n\'existe pas.')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(recipe.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  Center(
                    child: Hero(
                      tag: 'recipe-emoji-${recipe.id}',
                      child: Text(recipe.emoji,
                          style: const TextStyle(fontSize: 90)),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Chip(
                      label: Text(recipe.difficulty),
                      backgroundColor:
                          Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(label: Text(recipe.category)),
                      const SizedBox(width: 8),
                      Icon(Icons.timer_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 4),
                      Text('${recipe.prepTimeMinutes} minutes'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Description',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(recipe.description),
                  const SizedBox(height: 20),
                  Text('Ingrédients',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: recipe.ingredients
                            .map((ingredient) => ListTile(
                                  dense: true,
                                  leading: const Icon(
                                      Icons.check_circle_outline,
                                      size: 20),
                                  title: Text(ingredient),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
