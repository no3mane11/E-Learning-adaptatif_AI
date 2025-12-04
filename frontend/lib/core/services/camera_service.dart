import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

/// Service de gestion de la caméra
class CameraService {
  CameraService._();
  static final CameraService instance = CameraService._();

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  /// Initialiser la caméra frontale
  Future<bool> initialize() async {
    try {
      // 1. Demander permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        print('❌ Permission caméra refusée');
        return false;
      }

      // 2. Obtenir caméras disponibles
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        print('❌ Aucune caméra disponible');
        return false;
      }

      // 3. Trouver caméra frontale
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      // 4. Créer controller
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium, // Résolution moyenne (économie batterie)
        enableAudio: false, // Pas besoin d'audio
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // 5. Initialiser
      await _controller!.initialize();

      _isInitialized = true;
      print('✅ Caméra initialisée avec succès');
      return true;
    } catch (e) {
      print('❌ Erreur init caméra: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Capturer une image
  Future<XFile?> captureImage() async {
    if (!_isInitialized || _controller == null) {
      print('❌ Caméra pas initialisée');
      return null;
    }

    try {
      if (!_controller!.value.isTakingPicture) {
        final image = await _controller!.takePicture();
        return image;
      }
      return null;
    } catch (e) {
      print('❌ Erreur capture: $e');
      return null;
    }
  }

  /// Obtenir un frame pour l'analyse d'émotions
  Future<img.Image?> getFrameForAnalysis() async {
    if (!_isInitialized || _controller == null) {
      return null;
    }

    try {
      final file = await captureImage();
      if (file == null) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      return image;
    } catch (e) {
      print('❌ Erreur getFrameForAnalysis: $e');
      return null;
    }
  }

  /// Stream de frames en continu (optionnel, plus avancé)
  void startImageStream(Function(CameraImage) onImage) {
    if (_isInitialized && _controller != null) {
      _controller!.startImageStream((image) {
        onImage(image);
      });
    }
  }

  void stopImageStream() {
    try {
      _controller?.stopImageStream();
    } catch (e) {
      // Ignorer les erreurs si le stream n'est pas actif
    }
  }

  /// Basculer entre caméras
  Future<bool> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      return false;
    }

    try {
      await dispose();
      final currentIndex = _cameras!.indexWhere(
        (camera) => camera == _controller?.description,
      );
      final nextIndex = (currentIndex + 1) % _cameras!.length;
      final nextCamera = _cameras![nextIndex];

      _controller = CameraController(
        nextCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _isInitialized = true;
      return true;
    } catch (e) {
      print('❌ Erreur switchCamera: $e');
      return false;
    }
  }

  /// Libérer les ressources
  Future<void> dispose() async {
    stopImageStream();
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
}
