# BE-Flutter 🧠

> **Mood & Habit Tracker Personnel**

BE-Flutter est une application de suivi personnel conçue pour vous aider à tenir vos engagements et surveiller votre bien-être mental. 

Elle repose sur le concept d'**"Expérience"** : une période dédiée à un objectif précis, un changement d'habitude ou un défi personnel (exemple : *"Arrêter les réseaux sociaux"*, *"Mois sans sucre"*, *"Méditation quotidienne"*).

---

## 🎯 Concept

L'application utilise une terminologie spécifique pour ludifier et structurer votre développement personnel :

- **L'Expérience** : C'est votre objectif ou le défi que vous vous lancez. Elle agit comme un conteneur pour votre suivi.
- **Le Contrat** : C'est la règle du jeu que vous fixez pour cette expérience (ex: "Ne pas ouvrir Instagram de la journée").
- **Le Suivi Journalier** : Chaque jour, vous évaluez votre réussite.

---

## 🚀 Fonctionnalités

### 1. Gestion des Objectifs (Expériences)
- **Création** : Définissez un nouveau défi (ex: "Détox Dopamine").
- **Suivi Long Terme** : Gardez l'historique de tous vos défis passés et actuels.
- **Gestion** : Modifiez ou supprimez des suivis selon l'évolution de vos besoins.

### 2. Journal de Bord Quotidien
Pour chaque expérience active, notez quotidiennement vos résultats :
- **Notation (Mood)** : Notez votre humeur ou votre ressenti global de la journée (1 à 5).
- **Validation du Contrat** : Cochez simplement si vous avez tenu votre engagement (Oui/Non).
- **Calendrier** : Visualisez vos jours réussis et vos jours "sans".

### 3. Analyse de Progression
- **Score Moyen** : Suivez la moyenne de votre humeur/réussite sur la durée de l'expérience.
- **Vue Détaillée** : Analysez la corrélation entre le respect de votre contrat et votre humeur générale.
- **Graphiques** : Visualisation de la courbe de progression ( *En cours d'implémentation* ).

### 4. Persistance & Confidentialité
- Vos données sont stockées localement sur votre machine. Rien n'est envoyé dans le cloud.

---

## 🛠 Stack Technique

Application convertie depuis Qt/C++ vers l'écosystème Flutter moderne :

| Catégorie | Technologie | Usage |
|-----------|-------------|-------|
| **Framework** | [Flutter](https://flutter.dev) | UI Multiplateforme (Windows focus) |
| **Langage** | Dart 3 | Logique métier |
| **State Management** | [Riverpod](https://riverpod.dev) | Gestion d'état réactive |
| **Persistance** | [Shared Preferences](https://pub.dev/packages/shared_preferences) | Stockage local des données |
| **Sérialisation** | [Json Serializable](https://pub.dev/packages/json_serializable) | Conversion automatique JSON <-> Objets |

---

## 💻 Guide d'Installation

### Prérequis
- **Flutter SDK**
- **Dart SDK**

### Démarrage Rapide

1. **Cloner et installer**
   ```bash
   git clone https://github.com/votre-username/BE-Flutter.git
   cd BE-Flutter
   flutter pub get
   ```

2. **Générer le code**
   Indispensable pour la sérialisation des modèles JSON.
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Lancer**
   ```bash
   flutter run -d windows
   ```

---

## 🔧 Développement

### Architecture

```text
lib/
├── models/           # Données (Experience = Défi, Day = Entrée journalière)
├── providers/        # Logique (ExperienceProvider)
├── repositories/     # Sauvegarde
├── pages/            # Ecrans (Accueil, Détail du défi)
└── widgets/          # Composants graphiques
```

### Commandes utiles

- **Mode Watch (Dev)** : Régénération automatique des modèles pendant que vous codez.
  ```bash
  dart run build_runner watch --delete-conflicting-outputs
  ```

---

## 📝 Note de l'auteur

Ce projet est une réécriture d'un outil personnel visant à quantifier l'impact des habitudes sur le moral quotidien.
