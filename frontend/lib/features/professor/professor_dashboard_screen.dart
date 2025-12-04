import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';

/// Tableau de bord professeur
class ProfessorDashboardScreen extends StatelessWidget {
  const ProfessorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            _buildWelcomeCard()
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Stats
            _buildStats()
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Charts
            Text(
              'Analyses',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildCharts()
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Quick actions
            Text(
              'Actions rapides',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildQuickActions(context)
                .animate()
                .fadeIn(delay: 700.ms, duration: 600.ms),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              context.push('/professor/courses');
              break;
            case 2:
              context.push('/professor/analytics');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Mes cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analyses',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.largeAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour Professeur ! 👋',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textInverse,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Voici un aperçu de vos statistiques',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textInverse.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Cours', '12', Icons.book, AppColors.primary),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Étudiants',
            '245',
            Icons.people,
            AppColors.secondary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Engagement',
            '87%',
            Icons.trending_up,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 32),
          SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.h3),
          SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Column(
      children: [
        // Engagement chart
        Container(
          height: 200,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mediumAll,
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 0.7),
                    FlSpot(1, 0.8),
                    FlSpot(2, 0.75),
                    FlSpot(3, 0.85),
                    FlSpot(4, 0.9),
                    FlSpot(5, 0.88),
                    FlSpot(6, 0.92),
                  ],
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(
          context,
          'Créer un cours',
          Icons.add_circle,
          AppColors.primary,
          () => context.push('/professor/courses'),
        ),
        _buildActionCard(
          context,
          'Voir analyses',
          Icons.analytics,
          AppColors.secondary,
          () => context.push('/professor/analytics'),
        ),
        _buildActionCard(
          context,
          'Mes étudiants',
          Icons.people,
          AppColors.success,
          () {
            // TODO: Naviguer vers étudiants
          },
        ),
        _buildActionCard(
          context,
          'Paramètres',
          Icons.settings,
          AppColors.warning,
          () {
            // TODO: Naviguer vers paramètres
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mediumAll,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



