import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/buttons/button_size.dart';

/// Modal de consentement pour l'utilisation de la caméra
class CameraConsentDialog extends StatelessWidget {
  const CameraConsentDialog({
    super.key,
    required this.onAccept,
    required this.onRefuse,
  });

  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.largeAll,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animation Lottie
                Container(
                  width: 80,
                  height: 80,
                  child: Lottie.network(
                    'https://assets4.lottiefiles.com/packages/lf20_camera.json',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback si l'URL ne fonctionne pas
                      return Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: AppColors.primary,
                      );
                    },
                  ),
                )
                    .animate()
                    .scale(
                      delay: 100.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .fadeIn(
                      delay: 100.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Titre
                Text(
                  'Activer la détection d\'émotions ?',
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
                      duration: 600.ms,
                    )
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      delay: 200.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.sm),
                // Description
                Text(
                  'Nous utilisons ta caméra pour analyser ton engagement et améliorer ton expérience d\'apprentissage.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                      delay: 300.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.sm),
                // Bullet points
                Column(
                  children: [
                    _buildBulletPoint('✓ Détecter quand tu es frustré'),
                    SizedBox(height: 4),
                    _buildBulletPoint('✓ T\'aider au bon moment'),
                    SizedBox(height: 4),
                    _buildBulletPoint('✓ Améliorer ton expérience'),
                  ],
                ).animate().fadeIn(
                      delay: 400.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.sm),
                // Sécurité
                Container(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: AppRadius.mediumAll,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 14,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Tes images ne sont jamais sauvegardées',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                      delay: 500.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        onPressed: onRefuse,
                        label: 'Refuser',
                        size: ButtonSize.small,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: onAccept,
                        label: 'Accepter',
                        icon: Icons.check,
                        size: ButtonSize.small,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      delay: 600.ms,
                      duration: 600.ms,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: 600.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.xs),
                // Lien "En savoir plus"
                TextButton(
                  onPressed: () {
                    // TODO: Ouvrir page politique confidentialité
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'En savoir plus',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ).animate().fadeIn(
                      delay: 700.ms,
                      duration: 600.ms,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          size: 14,
          color: AppColors.success,
        ),
        SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
