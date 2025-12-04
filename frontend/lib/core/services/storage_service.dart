import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de stockage sécurisé et préférences
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage (tokens, données sensibles)
  Future<void> setSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }

  // SharedPreferences (préférences utilisateur)
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  // Helpers spécifiques
  Future<void> saveToken(String token) async {
    await setSecure('auth_token', token);
  }

  Future<String?> getToken() async {
    return await getSecure('auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await setSecure('refresh_token', token);
  }

  Future<String?> getRefreshToken() async {
    return await getSecure('refresh_token');
  }

  Future<void> clearAuth() async {
    await deleteSecure('auth_token');
    await deleteSecure('refresh_token');
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await setBool('onboarding_completed', completed);
  }

  bool? isOnboardingCompleted() {
    return getBool('onboarding_completed') ?? false;
  }

  Future<void> setCameraConsent(bool consented) async {
    await setBool('camera_consent', consented);
  }

  bool? hasCameraConsent() {
    return getBool('camera_consent') ?? false;
  }
}



