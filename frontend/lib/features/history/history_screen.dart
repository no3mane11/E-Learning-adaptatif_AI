import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/utils/helpers.dart';
import '../../shared/models/session_model.dart';

/// Écran d'historique des sessions
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedPeriod = 'Semaine';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Semaine', child: Text('Semaine')),
              PopupMenuItem(value: 'Mois', child: Text('Mois')),
              PopupMenuItem(value: 'Année', child: Text('Année')),
            ],
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats summary
            _buildStatsSummary()
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Chart
            _buildEngagementChart()
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Sessions list
            Text(
              'Sessions récentes',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildSessionsList()
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Sessions',
            '24',
            Icons.play_circle,
            AppColors.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Temps total',
            '12h 30m',
            Icons.access_time,
            AppColors.secondary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Engagement',
            '85%',
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
          Icon(icon, color: color, size: 28),
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

  Widget _buildEngagementChart() {
    return Container(
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
    );
  }

  Widget _buildSessionsList() {
    // TODO: Récupérer les sessions depuis l'API
    final sessions = <SessionModel>[]; // Mock data

    if (sessions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mediumAll,
        ),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucune session',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: sessions.asMap().entries.map((entry) {
        final index = entry.key;
        final session = entry.value;
        return _buildSessionItem(session)
            .animate()
            .fadeIn(
              delay: (600 + index * 50).ms,
              duration: 600.ms,
            )
            .slideX(
              begin: -0.1,
              end: 0,
              delay: (600 + index * 50).ms,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            );
      }).toList(),
    );
  }

  Widget _buildSessionItem(SessionModel session) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_circle,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session de leçon',
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      Helpers.formatDuration(Duration(seconds: session.duration)),
                      style: AppTextStyles.caption,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.trending_up,
                      size: 14,
                      color: AppColors.success,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '${(session.averageEngagement * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Date
          Text(
            session.completedAt != null
                ? Helpers.formatRelativeDate(session.completedAt!)
                : '',
            style: AppTextStyles.captionSmall,
          ),
        ],
      ),
    );
  }
}



