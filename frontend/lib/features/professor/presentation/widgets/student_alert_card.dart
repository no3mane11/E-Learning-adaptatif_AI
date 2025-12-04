import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';

/// Carte d'alerte pour un étudiant en difficulté
class StudentAlertCard extends StatelessWidget {
  const StudentAlertCard({
    super.key,
    required this.studentName,
    required this.courseName,
    required this.frustrationScore,
    required this.lastSession,
    required this.onContact,
  });

  final String studentName;
  final String courseName;
  final double frustrationScore; // 0-10
  final String lastSession;
  final VoidCallback onContact;

  Color _getFrustrationColor() {
    if (frustrationScore > 7) return AppColors.error;
    if (frustrationScore > 5) return AppColors.warning;
    return AppColors.success;
  }

  IconData _getFrustrationIcon() {
    if (frustrationScore > 7) return Icons.sentiment_very_dissatisfied;
    if (frustrationScore > 5) return Icons.sentiment_neutral;
    return Icons.sentiment_satisfied;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getFrustrationColor();
    final icon = _getFrustrationIcon();

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeAll,
        border: Border(
          left: BorderSide(color: color, width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar avec badge
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 1.5),
                  ),
                  child: Icon(
                    Icons.warning,
                    size: 7,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: AppSpacing.xs),
          // Informations étudiant
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  studentName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Text(
                  'Cours: $courseName',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.trending_down,
                      size: 11,
                      color: color,
                    ),
                    SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        'Score: ${frustrationScore.toStringAsFixed(1)}/10',
                        style: AppTextStyles.captionSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Dernière session: $lastSession',
                  style: AppTextStyles.captionSmall.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 4),
          // Indicateur frustration + bouton
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular progress
              Stack(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      value: frustrationScore / 10,
                      strokeWidth: 2.5,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        icon,
                        size: 14,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              // Bouton contacter - Utiliser un TextButton plus compact
              SizedBox(
                height: 24,
                child: TextButton(
                  onPressed: onContact,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Contacter',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(
          begin: -0.1,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }
}


