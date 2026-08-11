import '../models/recipe.dart';

/// Exception levée par [RecipeRepository] en cas d'échec de lecture des
/// données (ex: source externe indisponible dans une future évolution
/// de l'app avec une vraie API/BDD).
class RecipeRepositoryException implements Exception {
  final String message;
  const RecipeRepositoryException(this.message);

  @override
  String toString() => 'RecipeRepositoryException: $message';
}

/// Source de données pour les recettes.
///
/// Dans une vraie application, ces données viendraient d'une API ou
/// d'une base de données locale. Elles sont volontairement isolées ici
/// (hors des widgets) pour respecter la séparation UI / données.
///
/// Le repository est **instanciable** (et non statique) afin de pouvoir
/// être injecté dans [RecipeProvider] et remplacé facilement par un
/// double de test (mock/fake) dans les tests unitaires. Un repository
/// entièrement statique ne peut pas être substitué, ce qui rend le
/// provider difficile à tester en isolation.
class RecipeRepository {
  const RecipeRepository();

  /// Retourne le jeu de recettes initial.
  ///
  /// Lève une [RecipeRepositoryException] si les données ne peuvent pas
  /// être fournies, pour permettre à l'appelant (ici [RecipeProvider])
  /// de gérer l'erreur proprement plutôt que de planter l'app.
  List<Recipe> getInitialRecipes() {
    try {
      return const [
        Recipe(
          id: 'r1',
          title: 'Poulet au coco',
          category: 'Plat',
          prepTimeMinutes: 45,
          difficulty: 'Moyen',
          description:
              'Un poulet mijoté dans du lait de coco avec des épices douces, '
              'servi traditionnellement avec du riz blanc.',
          emoji: '🍛',
          ingredients: ['Poulet', 'Lait de coco', 'Ail', 'Gingembre', 'Riz'],
        ),
        Recipe(
          id: 'r2',
          title: 'Salade César',
          category: 'Entrée',
          prepTimeMinutes: 15,
          difficulty: 'Facile',
          description:
              'Salade croquante avec poulet grillé, parmesan, croûtons et '
              'sauce César maison.',
          emoji: '🥗',
          ingredients: [
            'Laitue',
            'Poulet',
            'Parmesan',
            'Croûtons',
            'Sauce César',
          ],
        ),
        Recipe(
          id: 'r3',
          title: 'Tarte au citron',
          category: 'Dessert',
          prepTimeMinutes: 60,
          difficulty: 'Difficile',
          description:
              'Une tarte acidulée et sucrée avec une pâte sablée croustillante '
              'et une garniture au citron onctueuse.',
          emoji: '🍋',
          ingredients: ['Farine', 'Beurre', 'Citron', 'Œufs', 'Sucre'],
        ),
        Recipe(
          id: 'r4',
          title: 'Soupe miso',
          category: 'Entrée',
          prepTimeMinutes: 20,
          difficulty: 'Facile',
          description:
              'Soupe japonaise légère à base de pâte de miso, tofu et algues '
              'wakame.',
          emoji: '🍜',
          ingredients: ['Pâte miso', 'Tofu', 'Algues wakame', 'Oignon vert'],
        ),
        Recipe(
          id: 'r5',
          title: 'Burger maison',
          category: 'Plat',
          prepTimeMinutes: 30,
          difficulty: 'Moyen',
          description:
              'Un burger généreux avec steak haché, cheddar fondu, salade et '
              'sauce maison, le tout dans un pain brioché.',
          emoji: '🍔',
          ingredients: [
            'Pain brioché',
            'Steak haché',
            'Cheddar',
            'Salade',
            'Sauce',
          ],
        ),
        Recipe(
          id: 'r6',
          title: 'Brownie chocolat',
          category: 'Dessert',
          prepTimeMinutes: 40,
          difficulty: 'Facile',
          description:
              'Un brownie fondant au chocolat noir, avec un cœur moelleux et '
              'des éclats de noix.',
          emoji: '🍫',
          ingredients: [
            'Chocolat noir',
            'Beurre',
            'Œufs',
            'Sucre',
            'Farine',
            'Noix',
          ],
        ),
      ];
    } catch (e) {
      throw RecipeRepositoryException(
        'Impossible de charger les recettes initiales: $e',
      );
    }
  }

  /// Retourne la liste des catégories disponibles, "Tous" inclus en
  /// première position pour le filtre "afficher tout".
  List<String> getCategories() {
    return const ['Tous', 'Entrée', 'Plat', 'Dessert'];
  }
}
