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

  /// URL ou chemin d'asset d'une vraie image, optionnel. Le projet utilise
  /// volontairement un [emoji] comme représentation visuelle simple pour
  /// éviter toute dépendance réseau dans ce MVP pédagogique. Ce champ est
  /// prévu pour permettre une évolution ultérieure (affichage d'une vraie
  /// photo) sans devoir changer la signature du modèle : `imageUrl` peut
  /// être renseigné en plus (ou à la place, selon l'UI) de `emoji`.
  final String? imageUrl;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.prepTimeMinutes,
    required this.difficulty,
    required this.description,
    required this.emoji,
    required this.ingredients,
    this.imageUrl,
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
    String? imageUrl,
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
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
