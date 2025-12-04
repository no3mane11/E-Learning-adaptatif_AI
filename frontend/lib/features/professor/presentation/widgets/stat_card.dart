import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';

/// Carte de statistique pour le dashboard professeur
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    this.trend,
    this.onTap,
    this.progress,
  });

  final IconData icon;
  final String value;
  final String label;
  final LinearGradient gradient;
  final String? trend;
  final VoidCallback? onTap;
  final double? progress; // Pour la progress bar circulaire (0.0 à 1.0)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: AppRadius.largeAll,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon avec progress circulaire si nécessaire
            if (progress != null)
              Stack(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              )
            else
              Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: AppSpacing.sm),
            // Valeur
            Text(
              value,
              style: AppTextStyles.h2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2),
            // Label
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            // Trend si présent
            if (trend != null) ...[
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      trend!,
                      style: AppTextStyles.captionSmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
        .then()
        .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.1));
  }
}


