import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/utils/helpers.dart';

/// Écran de notifications et recommandations
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Notifications'),
            Tab(text: 'Recommandations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildNotificationsTab(), _buildRecommendationsTab()],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    // TODO: Récupérer les notifications depuis l'API
    final notifications = <NotificationItem>[]; // Mock data

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucune notification',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index])
            .animate()
            .fadeIn(delay: (index * 50).ms, duration: 600.ms)
            .slideX(
              begin: -0.1,
              end: 0,
              delay: (index * 50).ms,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildRecommendationsTab() {
    // TODO: Récupérer les recommandations depuis l'API
    final recommendations = <RecommendationItem>[]; // Mock data

    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucune recommandation',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        return _buildRecommendationItem(recommendations[index])
            .animate()
            .fadeIn(delay: (index * 50).ms, duration: 600.ms)
            .slideY(
              begin: 0.1,
              end: 0,
              delay: (index * 50).ms,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.surface
            : AppColors.primary.withOpacity(0.05),
        borderRadius: AppRadius.mediumAll,
        border: Border.all(
          color: notification.isRead
              ? AppColors.border
              : AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: notification.type.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.type.icon,
              color: notification.type.color,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: notification.isRead
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  notification.message,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  Helpers.formatRelativeDate(notification.date),
                  style: AppTextStyles.captionSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(RecommendationItem recommendation) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            recommendation.color.withOpacity(0.1),
            recommendation.color.withOpacity(0.05),
          ],
        ),
        borderRadius: AppRadius.mediumAll,
        border: Border.all(color: recommendation.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: recommendation.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              recommendation.icon,
              color: recommendation.color,
              size: 28,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Action button
          IconButton(
            icon: Icon(Icons.arrow_forward),
            color: recommendation.color,
            onPressed: recommendation.onTap,
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
    required this.type,
  });
}

enum NotificationType {
  course(Icons.book, AppColors.primary),
  lesson(Icons.play_circle, AppColors.secondary),
  achievement(Icons.emoji_events, AppColors.warning),
  system(Icons.info, AppColors.textSecondary);

  final IconData icon;
  final Color color;

  const NotificationType(this.icon, this.color);
}

class RecommendationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  RecommendationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}


