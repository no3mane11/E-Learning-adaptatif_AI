import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/helpers.dart';
import '../../shared/widgets/buttons/secondary_button.dart';
import '../../shared/widgets/buttons/button_size.dart';

/// Écran de profil et paramètres
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Éditer le profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            _buildProfileHeader()
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Stats
            _buildStats()
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Settings sections
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paramètres',
                    style: AppTextStyles.h3,
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms),
                  SizedBox(height: AppSpacing.md),
                  _buildSettingsSection()
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 600.ms),
                  SizedBox(height: AppSpacing.xl),
                  Text(
                    'À propos',
                    style: AppTextStyles.h3,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms),
                  SizedBox(height: AppSpacing.md),
                  _buildAboutSection()
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 600.ms),
                  SizedBox(height: AppSpacing.xl),
                  // Logout button
                  SecondaryButton(
                    onPressed: _handleLogout,
                    label: 'Déconnexion',
                    size: ButtonSize.large,
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 600.ms),
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.textInverse,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textInverse,
                width: 4,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Name
          Text(
            'Utilisateur', // TODO: Récupérer depuis l'API
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textInverse,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          // Email
          Text(
            'user@example.com', // TODO: Récupérer depuis l'API
            style: AppTextStyles.body.copyWith(
              color: AppColors.textInverse.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Cours complétés', '12', Icons.check_circle),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatItem('Leçons', '45', Icons.play_circle),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildStatItem('Streak', '7', Icons.local_fire_department),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.h3,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {
            // TODO: Ouvrir paramètres notifications
          },
        ),
        _buildSettingItem(
          icon: Icons.camera_alt_outlined,
          title: 'Caméra',
          onTap: () {
            // TODO: Ouvrir paramètres caméra
          },
        ),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Langue',
          onTap: () {
            // TODO: Ouvrir sélection langue
          },
        ),
        _buildSettingItem(
          icon: Icons.dark_mode_outlined,
          title: 'Thème',
          onTap: () {
            // TODO: Changer thème
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.help_outline,
          title: 'Aide & Support',
          onTap: () {
            // TODO: Ouvrir aide
          },
        ),
        _buildSettingItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Confidentialité',
          onTap: () {
            // TODO: Ouvrir politique confidentialité
          },
        ),
        _buildSettingItem(
          icon: Icons.info_outline,
          title: 'À propos',
          onTap: () {
            // TODO: Ouvrir à propos
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mediumAll,
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Déconnexion',
      message: 'Êtes-vous sûr de vouloir vous déconnecter ?',
    );

    if (confirmed) {
      await AuthService.instance.logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }
}

