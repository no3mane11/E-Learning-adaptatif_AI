import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/services/camera_service.dart';
import '../../core/services/emotion_service.dart';
import '../../core/services/storage_service.dart';
import 'presentation/widgets/camera_consent_dialog.dart';

/// Écran de lecture de leçon avec caméra et détection d'émotions
class LessonPlayerScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  // ═══════════════════════════════════════════════════
  // VARIABLES
  // ═══════════════════════════════════════════════════

  final CameraService _cameraService = CameraService.instance;
  final EmotionService _emotionService = EmotionService.instance;

  bool _isCameraInitialized = false;
  bool _cameraEnabled = false;
  Timer? _captureTimer;
  String? _sessionId;

  // Progress
  int _elapsedSeconds = 0;
  double _completionPercentage = 0.02; // 2%
  Timer? _progressTimer;

  // Frustration
  double _frustrationScore = 0.0;
  String _frustrationLevel = 'Normal';

  // ═══════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    // 1. Démarrer la session
    _startSession();

    // 2. Démarrer le timer de progression
    _startProgressTimer();

    // 3. Attendre 1 seconde puis demander consentement caméra
    Future.delayed(Duration(seconds: 1), () {
      _showCameraConsentDialog();
    });
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _captureTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════
  // SESSION
  // ═══════════════════════════════════════════════════

  Future<void> _startSession() async {
    // TODO: Appel API pour créer session
    setState(() {
      _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;

          // Augmenter progression (simulation)
          if (_completionPercentage < 1.0) {
            _completionPercentage += 0.0001;
          }
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // ═══════════════════════════════════════════════════
  // MODAL CONSENTEMENT
  // ═══════════════════════════════════════════════════

  void _showCameraConsentDialog() {
    // Vérifier si déjà consenti
    final hasConsent = StorageService.instance.hasCameraConsent() ?? false;
    if (hasConsent) {
      _initializeCamera();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CameraConsentDialog(
        onAccept: () async {
          Navigator.pop(context);
          await StorageService.instance.setCameraConsent(true);
          await _initializeCamera();
        },
        onRefuse: () {
          Navigator.pop(context);
          setState(() => _cameraEnabled = false);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // INITIALISATION CAMÉRA
  // ═══════════════════════════════════════════════════

  Future<void> _initializeCamera() async {
    setState(() => _isCameraInitialized = false);

    final success = await _cameraService.initialize();

    if (success) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _cameraEnabled = true;
        });

        // Démarrer capture périodique
        _startPeriodicCapture();

        // Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('✅ Caméra activée'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() => _cameraEnabled = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'activer la caméra'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════
  // CAPTURE PÉRIODIQUE
  // ═══════════════════════════════════════════════════

  void _startPeriodicCapture() {
    // Capturer toutes les 3 secondes
    _captureTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await _captureAndAnalyze();
    });
  }

  Future<void> _captureAndAnalyze() async {
    if (!_cameraEnabled || _sessionId == null) {
      return;
    }

    try {
      // 1. Capturer image
      final image = await _cameraService.captureImage();
      if (image == null) return;

      // 2. Lire bytes
      final bytes = await image.readAsBytes();

      // 3. Analyser émotion
      final result = await _emotionService.analyzeEmotionFromImage(bytes);

      if (result != null && mounted) {
        final score = result['frustrationScore'] as double? ?? 0.0;
        setState(() {
          _frustrationScore = score;
          // Déterminer le niveau
          if (score >= 7.0) {
            _frustrationLevel = 'Élevé';
          } else if (score >= 4.0) {
            _frustrationLevel = 'Moyen';
          } else {
            _frustrationLevel = 'Normal';
          }
        });

        print('📸 Image capturée et analysée');
        print('Session ID: $_sessionId');
        print('Score frustration: $_frustrationScore');
      }
    } catch (e) {
      print('❌ Erreur capture: $e');
    }
  }

  // ═══════════════════════════════════════════════════
  // UI BUILD
  // ═══════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5FF),
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────────────
            // HEADER
            // ─────────────────────────────────────────
            _buildHeader(),

            // ─────────────────────────────────────────
            // PROGRESS BAR
            // ─────────────────────────────────────────
            _buildProgressBar(),

            // ─────────────────────────────────────────
            // CONTENT SCROLLABLE
            // ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION PROGRESSION
                    _buildProgressSection(),

                    SizedBox(height: 16),

                    // SECTION CAMÉRA (COMME LA PHOTO)
                    _buildCameraSection(),

                    SizedBox(height: 16),

                    // SECTION CONTENU LEÇON
                    _buildLessonContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),

          SizedBox(width: 12),

          // Titre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session active',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'En cours',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Badge LIVE
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: Offset(1.0, 1.0),
                      end: Offset(1.3, 1.3),
                      duration: 1000.ms,
                    ),
                SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // PROGRESS BAR
  // ═══════════════════════════════════════════════════

  Widget _buildProgressBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: _completionPercentage,
          minHeight: 8,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // SECTION PROGRESSION
  // ═══════════════════════════════════════════════════

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progression',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${(_completionPercentage * 100).toInt()}% complété',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatDuration(_elapsedSeconds),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // SECTION CAMÉRA (COMME LA PHOTO) ← IMPORTANT !
  // ═══════════════════════════════════════════════════

  Widget _buildCameraSection() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE8F5E9), // Vert très clair
        border: Border.all(color: Color(0xFF4CAF50), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre et badge
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Caméra',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                // Badge ENREGISTREMENT (comme la photo)
                if (_cameraEnabled)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .scale(
                              begin: Offset(1.0, 1.0),
                              end: Offset(1.4, 1.4),
                              duration: 1000.ms,
                            ),
                        SizedBox(width: 6),
                        Text(
                          'ENREGISTREMENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Preview caméra (COMME LA PHOTO)
          if (_isCameraInitialized && _cameraService.controller != null)
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF4CAF50), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CameraPreview(_cameraService.controller!),
              ),
            )
          else if (_cameraEnabled && !_isCameraInitialized)
            // Loading
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            // Caméra désactivée
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Caméra désactivée',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: _initializeCamera,
                      child: Text('Activer'),
                    ),
                  ],
                ),
              ),
            ),

          // Statut caméra activée + Frustration
          if (_cameraEnabled)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFF4CAF50),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Caméra activée',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  // Badge Frustration (comme la photo)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _frustrationScore >= 7.0
                          ? Colors.red.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: _frustrationScore >= 7.0
                            ? Colors.red
                            : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _frustrationScore >= 7.0
                                ? Colors.red
                                : Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Frustration',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          _frustrationLevel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _frustrationScore >= 7.0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${(_frustrationScore * 10).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _frustrationScore >= 7.0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // SECTION CONTENU LEÇON
  // ═══════════════════════════════════════════════════

  Widget _buildLessonContent() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, size: 20),
              SizedBox(width: 8),
              Text(
                'Contenu de la leçon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Théorie
          _buildContentItem(
            icon: Icons.description,
            title: 'Théorie',
            subtitle:
                'Les émotions influencent la mémoire. Note tes ressentis pendant la leçon.',
          ),

          SizedBox(height: 12),

          // Vidéo
          _buildContentItem(
            icon: Icons.play_circle_outline,
            title: 'Vidéo',
            subtitle: 'Lecture du module vidéo',
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF667EEA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pause, size: 14, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Pause',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to content
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
