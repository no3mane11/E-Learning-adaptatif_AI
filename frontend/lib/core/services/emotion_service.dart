import 'dart:convert';
import 'dart:math';
import '../constants/api_constants.dart';
import 'api_client.dart';

/// Service d'analyse d'émotions
class EmotionService {
  EmotionService._();
  static final EmotionService instance = EmotionService._();

  final _random = Random();

  /// Analyser émotion (envoie au backend)
  Future<double> analyzeEmotion({
    required String sessionId,
    required String imageBase64,
  }) async {
    // Mode mock pour le développement
    if (ApiConstants.useMockData) {
      return analyzeMock();
    }

    try {
      final response = await ApiClient.instance.dio.post(
        '/api/sessions/$sessionId/emotion',
        data: {
          'image': imageBase64,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Backend retourne: {frustrationScore: 7.5}
      final score = response.data['frustrationScore'] as double;
      return score;
    } catch (e) {
      print('❌ Erreur analyse émotion: $e');
      return 0.0;
    }
  }

  /// Analyser émotion depuis une image (bytes)
  Future<Map<String, dynamic>?> analyzeEmotionFromImage(
    List<int> imageBytes,
  ) async {
    // Mode mock pour le développement
    if (ApiConstants.useMockData) {
      return analyzeMockFull();
    }

    try {
      final base64Image = base64Encode(imageBytes);
      final response = await ApiClient.instance.dio.post(
        ApiConstants.emotionAnalysis,
        data: {
          'image': base64Image,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return {
        'emotion': response.data['emotion'] ?? 'neutral',
        'confidence': response.data['confidence'] ?? 0.0,
        'frustrationScore': response.data['frustrationScore'] ?? 0.0,
        'probabilities': response.data['probabilities'] ?? {},
      };
    } catch (e) {
      print('❌ Erreur analyse émotion: $e');
      return null;
    }
  }

  /// Version mock (pour tester sans backend IA)
  Future<double> analyzeMock() async {
    await Future.delayed(Duration(milliseconds: 500));

    // Score aléatoire entre 0 et 10
    return _random.nextDouble() * 10;
  }

  /// Version mock complète
  Future<Map<String, dynamic>> analyzeMockFull() async {
    await Future.delayed(Duration(milliseconds: 500));

    final emotions = ['happy', 'neutral', 'sad', 'angry', 'surprised'];
    final emotion = emotions[_random.nextInt(emotions.length)];
    final frustrationScore = _random.nextDouble() * 10;

    return {
      'emotion': emotion,
      'confidence': _random.nextDouble(),
      'frustrationScore': frustrationScore,
      'probabilities': {
        'happy': _random.nextDouble(),
        'neutral': _random.nextDouble(),
        'sad': _random.nextDouble(),
        'angry': _random.nextDouble(),
        'surprised': _random.nextDouble(),
      },
    };
  }
}
