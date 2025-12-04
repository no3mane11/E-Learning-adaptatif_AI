# E-Learning App

Application d'apprentissage avec détection d'émotions par IA, développée avec Flutter.

## 🚀 Fonctionnalités

### Étudiant
- ✅ Splash & Onboarding
- ✅ Authentification (Login/Signup)
- ✅ Accueil avec statistiques
- ✅ Liste et détails des cours
- ✅ Lecteur de leçon avec caméra
- ✅ Détection d'émotions en temps réel
- ✅ Historique des sessions
- ✅ Notifications et recommandations
- ✅ Profil et paramètres

### Professeur
- ✅ Tableau de bord
- ✅ Gestion des cours
- ✅ Analyses détaillées
- ✅ Statistiques d'engagement
- ✅ Performance des étudiants

## 📦 Installation

1. Cloner le projet
```bash
git clone <repository-url>
cd elearning_app
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Générer les fichiers Freezed et JSON
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Lancer l'application
```bash
flutter run
```

## 🏗️ Structure du Projet

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/          # Design system
│   ├── constants/      # Constantes API
│   ├── services/        # Services (API, Auth, Camera, etc.)
│   ├── router/         # Navigation
│   └── utils/          # Helpers et validators
├── features/           # Écrans par fonctionnalité
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── courses/
│   ├── lesson/
│   ├── history/
│   ├── notifications/
│   ├── profile/
│   └── professor/
└── shared/             # Widgets et modèles partagés
    ├── widgets/
    └── models/
```

## 🎨 Design System

- **Couleurs**: Palette moderne avec gradients
- **Typography**: Poppins pour les titres, Inter pour le corps
- **Spacing**: Système basé sur des multiples de 4
- **Animations**: Flutter Animate pour des transitions fluides

## 🔧 Configuration

### API Backend

Modifier `lib/core/constants/api_constants.dart` pour configurer l'URL de votre backend.

### Modèle d'émotions

Placer votre modèle TensorFlow Lite dans `assets/models/emotion_model.tflite`.

## 📱 Prérequis

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / Xcode pour le développement mobile

## 🛠️ Technologies Utilisées

- **Flutter**: Framework UI
- **Riverpod**: Gestion d'état
- **Go Router**: Navigation
- **Dio**: Client HTTP
- **TensorFlow Lite**: Détection d'émotions
- **Camera**: Accès caméra
- **Fl Chart**: Graphiques et analyses

## 📝 Notes

- Les modèles Freezed nécessitent la génération de code
- Le modèle d'émotions doit être ajouté manuellement
- Configurer les permissions caméra dans AndroidManifest.xml et Info.plist

## 📄 Licence

Ce projet est sous licence MIT.



