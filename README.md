# BE-Flutter - Gestionnaire d'expériences

Application Flutter convertie depuis Qt/C++ pour gérer vos expériences professionnelles.

## Description

Cette application vous permet de :
- Créer et gérer des expériences professionnelles
- Noter vos journées de travail (échelle 1-5)
- Suivre le respect du contrat
- Visualiser les statistiques de vos expériences

## Architecture

### Structure du projet

```
lib/
├── models/           # Modèles de données
│   ├── day.dart
│   ├── experience.dart
│   └── *.g.dart     # Fichiers générés (JSON serialization)
├── providers/        # State management (Riverpod)
│   └── experience_provider.dart
├── repositories/     # Couche de persistance
│   └── experience_repository.dart
├── pages/           # Pages de l'application
│   ├── home_page.dart
│   └── experience_detail_page.dart
├── widgets/         # Widgets réutilisables
│   ├── experience_card.dart
│   └── add_experience_form.dart
└── main.dart        # Point d'entrée
```

### Technologies utilisées

- **Flutter** : Framework UI multiplateforme
- **Riverpod** : State management
- **shared_preferences** : Persistance locale des données
- **json_serializable** : Sérialisation JSON automatique
- **intl** : Formatage des dates

## Installation

### Prérequis

- Flutter SDK (>=3.0.0)
- Dart SDK
- Un éditeur (VS Code, Android Studio, etc.)

### Étapes

1. Cloner le repository
```bash
cd BE-Flutter
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Générer les fichiers de sérialisation (si nécessaire)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Lancer l'application
```bash
flutter run
```

## Utilisation

### Page principale

- Affiche la liste de toutes vos expériences
- Bouton "Créer une expérience" pour ajouter une nouvelle expérience
- Pour chaque expérience :
  - Bouton ✍️ pour modifier le titre
  - Bouton "Supprimer" pour supprimer l'expérience
  - Bouton "Voir" pour accéder aux détails

### Page de détail

- Affichage des informations complètes de l'expérience
- Formulaire pour noter vos journées :
  - Sélection de la date
  - Note de 1 à 5 étoiles
  - Checkbox "Contrat respecté"
- Bouton "Terminer l'expérience" pour afficher la moyenne

## Fonctionnalités

- ✅ Création d'expériences
- ✅ Modification du titre et des dates
- ✅ Suppression d'expériences
- ✅ Notation des journées
- ✅ Calcul de la moyenne des notes
- ✅ Persistance locale des données
- ⏳ Graphiques (à implémenter avec fl_chart)

## Développement

### Générer les fichiers de sérialisation

Après modification des modèles, exécutez :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Configuration VS Code

Le projet inclut des paramètres VS Code (`.vscode/settings.json`) qui masquent automatiquement :
- Les fichiers de build et cache (`.dart_tool`, `build/`)
- Les fichiers IDE (`.idea/`, `*.iml`)
- Les fichiers temporaires (`tmpclaude-*`, `.tmp/`)
- Les métadonnées (`.metadata`, `devtools_options.yaml`)

### Structure des dossiers ignorés

- `.tmp/` - Fichiers temporaires (ignoré par Git et masqué dans VS Code)
- `.dart_tool/` - Cache Dart/Flutter
- `build/` - Fichiers compilés

### Tests

```bash
flutter test
```