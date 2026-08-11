# 🍽️ Recipe App — App Flutter multi-écrans

Application Flutter de gestion de recettes de cuisine, réalisée pour valider
la maîtrise des widgets Flutter et de la navigation multi-écrans.

## 📱 Aperçu

| Écran d'accueil | Détail | Formulaire |
|---|---|---|
| ![Accueil](screenshots/home_light.png) | ![Détail](screenshots/detail.png) | ![Formulaire](screenshots/form.png) |

> Les captures ci-dessus sont des emplacements à remplacer — voir
> `screenshots/README.md` pour savoir comment les générer.

## ✅ Fonctionnalités

- **4 écrans distincts** :
  1. `HomeScreen` — liste des recettes avec recherche et filtres
  2. `DetailScreen` — détail d'une recette (paramètres passés via la route)
  3. `FormScreen` — formulaire d'ajout d'une recette avec validation
  4. `SettingsScreen` — gestion du thème clair / sombre
- **Navigation** avec [go_router](https://pub.dev/packages/go_router) et
  routes nommées (`home`, `recipeDetail`, `addRecipe`, `settings`)
- **Recherche et filtrage** par catégorie sur l'écran de liste
- **Passage de paramètres** : id dans l'URL (`/recipe/:id`) + objet complet
  passé en `extra` pour l'écran de détail
- **Formulaire avec validation** : 5 champs (titre, catégorie, temps de
  préparation, difficulté, description) avec règles de validation
  (champs obligatoires, longueur minimale, valeur numérique positive)
- **Thème clair / sombre** géré via `ThemeProvider` (Provider) et
  persistant pendant la session

## 🧱 Exigences techniques couvertes

**Widgets utilisés (8+)** : `ListView`, `GridView`, `Stack`, `Card`,
`Chip` / `ChoiceChip`, `Hero`, `SliverAppBar` / `CustomScrollView`,
`TextFormField`, `DropdownButtonFormField`, `SwitchListTile`,
`FloatingActionButton`, `CircleAvatar`...

**Widgets réutilisables** (`lib/widgets/`) :
- `RecipeCard` — carte de recette pour la vue liste
- `RecipeGrid` — grille de recettes pour la vue tablette
- `SearchField` — champ de recherche générique
- `CategoryFilterBar` — barre de filtres par catégorie (ChoiceChips)

**Responsive** : `HomeScreen` utilise un `LayoutBuilder` pour basculer
automatiquement entre une `ListView` (mobile, largeur ≤ 600) et une
`GridView` à 2 ou 3 colonnes (tablette, largeur > 600 / > 900).

**Séparation UI / données** : aucune donnée n'est écrite en dur dans les
widgets. Les recettes viennent de `lib/data/recipe_repository.dart`, et
l'état (liste filtrée, recherche, thème) est géré par des `ChangeNotifier`
dans `lib/providers/`.

**Testabilité** : `RecipeRepository` est une classe instanciable (et non
un ensemble de méthodes statiques), injectée dans `RecipeProvider` via son
constructeur (`RecipeProvider({RecipeRepository? repository})`). Cela
permet de fournir un faux repository dans les tests pour simuler des cas
d'erreur, sans dépendre des vraies données.

**Gestion des erreurs** : le chargement des recettes initiales est protégé
par un `try/catch`. En cas d'échec, l'app ne plante pas — elle démarre
avec une liste vide et affiche une bannière d'erreur sur `HomeScreen`
(voir `RecipeProvider.errorMessage`). `addRecipe` effectue aussi une
validation défensive minimale (titre non vide, temps de préparation > 0)
avant d'accepter une nouvelle recette.

## 📂 Structure du projet

```
recipe_app/
├── lib/
│   ├── main.dart                    # Point d'entrée, providers, thème
│   ├── models/
│   │   └── recipe.dart              # Modèle de données Recipe
│   ├── data/
│   │   └── recipe_repository.dart   # Source des données (séparée de l'UI)
│   ├── providers/
│   │   ├── recipe_provider.dart     # État: liste, recherche, filtre, ajout
│   │   └── theme_provider.dart      # État: thème clair/sombre
│   ├── router/
│   │   └── app_router.dart          # Configuration GoRouter (routes nommées)
│   ├── screens/
│   │   ├── home_screen.dart         # Écran 1: liste + recherche + filtre
│   │   ├── detail_screen.dart       # Écran 2: détail (paramètres de route)
│   │   ├── form_screen.dart         # Écran 3: formulaire + validation
│   │   └── settings_screen.dart     # Écran 4: thème clair/sombre
│   └── widgets/
│       ├── recipe_card.dart         # Réutilisable
│       ├── recipe_grid.dart         # Réutilisable
│       ├── search_field.dart        # Réutilisable
│       └── category_filter_bar.dart # Réutilisable
├── test/
│   ├── widget_test.dart              # Tests d'app (navigation, écrans)
│   ├── data/
│   │   └── recipe_repository_test.dart
│   ├── providers/
│   │   ├── recipe_provider_test.dart # Recherche, filtre, ajout, erreurs
│   │   └── theme_provider_test.dart
│   ├── widgets/
│   │   ├── recipe_card_test.dart
│   │   └── category_filter_bar_test.dart
│   └── screens/
│       └── form_screen_test.dart     # Validation + soumission du formulaire
├── screenshots/                     # Captures d'écran à ajouter
├── pubspec.yaml
└── README.md
```

## 🚀 Lancer le projet

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.19
  (Dart ≥ 3.3)
- Un émulateur Android/iOS, un navigateur (Chrome), ou un appareil physique

### Installation

```bash
git clone https://github.com/<ton-utilisateur>/recipe_app.git
cd recipe_app
flutter pub get
```

### Lancement

```bash
# Vérifier que tout est en ordre
flutter doctor

# Lister les appareils disponibles
flutter devices

# Lancer sur l'appareil/émulateur par défaut
flutter run

# Ou cibler explicitement Chrome (utile en environnement sans émulateur)
flutter run -d chrome

# Tester en mode tablette : redimensionner la fenêtre Chrome au-delà
# de 600px de large pour voir la vue en grille responsive
```

### Lancer les tests

```bash
flutter test
```

## 🗺️ Routes disponibles

| Route | Nom | Description |
|---|---|---|
| `/` | `home` | Liste des recettes |
| `/recipe/:id` | `recipeDetail` | Détail d'une recette (id en paramètre) |
| `/add` | `addRecipe` | Formulaire d'ajout d'une recette |
| `/settings` | `settings` | Paramètres (thème) |

## 📦 Dépendances principales

| Package | Usage |
|---|---|
| `go_router` | Navigation déclarative avec routes nommées |
| `provider` | Gestion d'état (thème, recettes) |

## 📝 Notes de conception

- Les recettes ajoutées via le formulaire ne persistent que pendant la
  session (pas de backend/base de données pour rester simple) — un bon
  axe d'amélioration serait d'ajouter `shared_preferences` ou `sqflite`.
- Le thème est réinitialisé à chaque redémarrage de l'app pour la même
  raison ; il serait facile de le persister avec `shared_preferences`.

## 📄 Licence

Projet réalisé à des fins pédagogiques.
