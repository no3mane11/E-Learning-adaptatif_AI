import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';

/// Écran d'analyses détaillées (professeur)
class ProfessorAnalyticsScreen extends StatelessWidget {
  const ProfessorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyses'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Engagement overview
            Text(
              'Engagement global',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildEngagementChart()
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Emotion distribution
            Text(
              'Distribution des émotions',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildEmotionChart()
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.xl),
            // Student performance
            Text(
              'Performance des étudiants',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildStudentPerformance()
                .animate()
                .fadeIn(delay: 700.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementChart() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
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

  Widget _buildEmotionChart() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
      ),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              title: 'Happy',
              color: AppColors.emotionHappy,
              radius: 80,
            ),
            PieChartSectionData(
              value: 30,
              title: 'Neutral',
              color: AppColors.emotionNeutral,
              radius: 80,
            ),
            PieChartSectionData(
              value: 20,
              title: 'Sad',
              color: AppColors.emotionSad,
              radius: 80,
            ),
            PieChartSectionData(
              value: 10,
              title: 'Angry',
              color: AppColors.emotionAngry,
              radius: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentPerformance() {
    // TODO: Récupérer les données depuis l'API
    final students = <Map<String, dynamic>>[]; // Mock data

    if (students.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mediumAll,
        ),
        child: Center(
          child: Text(
            'Aucune donnée disponible',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: students.map((student) {
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
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'] ?? 'Étudiant',
                      style: AppTextStyles.bodyMedium,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    LinearProgressIndicator(
                      value: student['progress'] ?? 0.0,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                '${((student['progress'] ?? 0.0) * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}



