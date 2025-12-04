# Guide de Configuration

## Étapes d'installation

### 1. Installer les dépendances Flutter

```bash
flutter pub get
```

### 2. Générer les fichiers Freezed et JSON

Les modèles utilisent Freezed pour la génération de code. Exécutez :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Cette commande génère :
- `*.freezed.dart` pour les modèles Freezed
- `*.g.dart` pour la sérialisation JSON

### 3. Configuration des assets

#### Modèle TensorFlow Lite

Placez votre modèle de détection d'émotions dans :
```
assets/models/emotion_model.tflite
```

#### Polices (optionnel)

Si vous avez les polices Poppins et Inter, placez-les dans :
```
assets/fonts/
```

Sinon, le système utilisera les polices par défaut.

### 4. Configuration Android

Ajoutez les permissions dans `android/app/src/main/AndroidManifest.xml` :

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 5. Configuration iOS

Ajoutez les permissions dans `ios/Runner/Info.plist` :

```xml
<key>NSCameraUsageDescription</key>
<string>Nous utilisons la caméra pour analyser votre engagement pendant l'apprentissage</string>
```

### 6. Configuration de l'API

Modifiez `lib/core/constants/api_constants.dart` pour configurer l'URL de votre backend :

```dart
static const String baseUrl = 'https://votre-api.com/api/v1';
```

## Vérification

Après avoir suivi ces étapes, vous devriez pouvoir lancer l'application :

```bash
flutter run
```

## Résolution des problèmes

### Erreurs de génération Freezed

Si vous rencontrez des erreurs, nettoyez et régénérez :

```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erreurs de modèle TensorFlow Lite

Assurez-vous que :
1. Le fichier `emotion_model.tflite` existe dans `assets/models/`
2. Le fichier est correctement référencé dans `pubspec.yaml`
3. Le modèle est compatible avec TensorFlow Lite Flutter



