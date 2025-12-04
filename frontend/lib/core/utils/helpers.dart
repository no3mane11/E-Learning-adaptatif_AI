import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Helpers utilitaires
class Helpers {
  Helpers._();

  /// Formate une durée en minutes:secondes
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Formate une date
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Formate une date relative (il y a X jours)
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years ${years > 1 ? 'ans' : 'an'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months ${months > 1 ? 'mois' : 'mois'}';
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} ${difference.inDays > 1 ? 'jours' : 'jour'}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} ${difference.inHours > 1 ? 'heures' : 'heure'}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} ${difference.inMinutes > 1 ? 'minutes' : 'minute'}';
    } else {
      return 'À l\'instant';
    }
  }

  /// Formate un pourcentage
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  /// Obtient la couleur selon l'émotion
  static Color getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
      case 'joyeux':
        return const Color(0xFF10B981);
      case 'sad':
      case 'triste':
        return const Color(0xFF3B82F6);
      case 'angry':
      case 'en colère':
        return const Color(0xFFEF4444);
      case 'surprised':
      case 'surpris':
        return const Color(0xFFF59E0B);
      case 'neutral':
      case 'neutre':
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// Obtient l'icône selon l'émotion
  static IconData getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
      case 'joyeux':
        return Icons.sentiment_very_satisfied;
      case 'sad':
      case 'triste':
        return Icons.sentiment_very_dissatisfied;
      case 'angry':
      case 'en colère':
        return Icons.sentiment_very_dissatisfied;
      case 'surprised':
      case 'surpris':
        return Icons.sentiment_satisfied;
      case 'neutral':
      case 'neutre':
      default:
        return Icons.sentiment_neutral;
    }
  }

  /// Vérifie si l'appareil est une tablette
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  /// Obtient la largeur responsive
  static double getResponsiveWidth(BuildContext context, {
    double mobile = 360,
    double tablet = 600,
  }) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 ? tablet : mobile;
  }

  /// Affiche un snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Affiche un dialog de confirmation
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}



