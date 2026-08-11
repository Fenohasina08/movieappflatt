import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/search_field.dart';

/// Écran 1 : liste des recettes avec recherche et filtrage.
/// S'adapte au format de l'écran (ListView sur mobile, GridView sur tablette).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetail(BuildContext context, Recipe recipe) {
    // Passage de paramètres : l'id dans l'URL + l'objet complet en "extra"
    // pour éviter une recherche supplémentaire côté écran de détail.
    context.push('/recipe/${recipe.id}', extra: recipe);
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final recipes = recipeProvider.filteredRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes recettes'),
        actions: [
          IconButton(
            tooltip: 'Paramètres',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchField(
              hintText: 'Rechercher une recette...',
              onChanged: recipeProvider.updateSearchQuery,
            ),
            const SizedBox(height: 10),
            CategoryFilterBar(
              categories: recipeProvider.categories,
              selectedCategory: recipeProvider.selectedCategory,
              onSelected: recipeProvider.updateCategory,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: recipes.isEmpty
                  ? const _EmptyState()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive : au-delà de 600 logical px de large,
                        // on considère qu'on est sur tablette -> grille.
                        final isTablet = constraints.maxWidth > 600;
                        if (isTablet) {
                          return RecipeGrid(
                            recipes: recipes,
                            crossAxisCount:
                                constraints.maxWidth > 900 ? 3 : 2,
                            onTap: (recipe) => _openDetail(context, recipe),
                          );
                        }
                        return ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return RecipeCard(
                              recipe: recipe,
                              onTap: () => _openDetail(context, recipe),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off,
              size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 8),
          const Text('Aucune recette trouvée'),
        ],
      ),
    );
  }
}
