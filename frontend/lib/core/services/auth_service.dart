import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_client.dart';
import 'storage_service.dart';

/// Service d'authentification
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<void> init() async {
    await ApiClient.instance.init();
  }

  /// Connexion
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    // Mode mock pour le développement
    if (ApiConstants.useMockData) {
      await Future.delayed(Duration(seconds: 1)); // Simuler un délai réseau
      await StorageService.instance.saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      return {
        'success': true,
        'user': {
          'id': '1',
          'email': email,
          'firstName': 'Utilisateur',
          'lastName': 'Test',
          'role': role ?? 'student',
        },
        'token': 'mock_token',
      };
    }

    try {
      final response = await ApiClient.instance.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final token = data['token'] as String;
      final refreshToken = data['refresh_token'] as String?;

      await StorageService.instance.saveToken(token);
      if (refreshToken != null) {
        await StorageService.instance.saveRefreshToken(refreshToken);
      }

      return {
        'success': true,
        'user': data['user'],
        'token': token,
      };
    } on DioException catch (e) {
      // Gestion silencieuse des erreurs de connexion
      if (e.type == DioExceptionType.connectionError) {
        return {
          'success': false,
          'error': 'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data['message'] ?? 'Erreur de connexion',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Une erreur est survenue',
      };
    }
  }

  /// Inscription
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? role,
  }) async {
    // Mode mock pour le développement
    if (ApiConstants.useMockData) {
      await Future.delayed(Duration(seconds: 1)); // Simuler un délai réseau
      await StorageService.instance.saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      return {
        'success': true,
        'user': {
          'id': '1',
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'role': role ?? 'student',
        },
        'token': 'mock_token',
      };
    }

    try {
      final response = await ApiClient.instance.dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          if (phone != null) 'phone': phone,
          if (role != null) 'role': role,
        },
      );

      final data = response.data;
      final token = data['token'] as String;
      final refreshToken = data['refresh_token'] as String?;

      await StorageService.instance.saveToken(token);
      if (refreshToken != null) {
        await StorageService.instance.saveRefreshToken(refreshToken);
      }

      return {
        'success': true,
        'user': data['user'],
        'token': token,
      };
    } on DioException catch (e) {
      // Gestion silencieuse des erreurs de connexion
      if (e.type == DioExceptionType.connectionError) {
        return {
          'success': false,
          'error': 'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
        };
      }
      return {
        'success': false,
        'error': e.response?.data['message'] ?? 'Erreur d\'inscription',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Une erreur est survenue',
      };
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    try {
      await ApiClient.instance.dio.post(ApiConstants.logout);
    } catch (e) {
      // Ignorer les erreurs de déconnexion
    } finally {
      await StorageService.instance.clearAuth();
    }
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final token = await StorageService.instance.getToken();
    return token != null;
  }

  /// Obtenir le token actuel
  Future<String?> getToken() async {
    return await StorageService.instance.getToken();
  }
}

