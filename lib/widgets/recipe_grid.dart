import 'package:flutter/material.dart';
import '../models/recipe.dart';

/// Widget réutilisable affichant une grille de recettes (utilisé sur tablette).
///
/// Reçoit la liste des recettes en paramètre : aucune donnée hardcodée ici.
class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe recipe) onTap;
  final int crossAxisCount;

  const RecipeGrid({
    super.key,
    required this.recipes,
    required this.onTap,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onTap(recipe),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.4),
                    alignment: Alignment.center,
                    child: Text(recipe.emoji,
                        style: const TextStyle(fontSize: 48)),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    color: Colors.black.withValues(alpha: 0.55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${recipe.category} · ${recipe.prepTimeMinutes} min',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
