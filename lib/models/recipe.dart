/// Modèle de données représentant une recette.
///
/// Ce fichier ne contient AUCUNE logique d'affichage : c'est uniquement
/// la structure de données, séparée des widgets (UI) conformément
/// à l'exigence "aucune donnée hardcodée dans les widgets".
class Recipe {
  final String id;
  final String title;
  final String category;
  final int prepTimeMinutes;
  final String difficulty; // Facile, Moyen, Difficile
  final String description;
  final String emoji; // utilisé comme "image" simple, sans dépendance réseau
  final List<String> ingredients;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.prepTimeMinutes,
    required this.difficulty,
    required this.description,
    required this.emoji,
    required this.ingredients,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? category,
    int? prepTimeMinutes,
    String? difficulty,
    String? description,
    String? emoji,
    List<String>? ingredients,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
