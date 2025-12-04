import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';

/// Écran de tableau de bord analytique pour professeur
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPeriod = '30 jours';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: '7 jours', child: Text('7 derniers jours')),
              PopupMenuItem(value: '30 jours', child: Text('30 derniers jours')),
              PopupMenuItem(value: '90 jours', child: Text('90 derniers jours')),
            ],
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Text(_selectedPeriod),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION 1: MÉTRIQUES GLOBALES
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Vues totales',
                    '12,345',
                    Icons.visibility,
                    AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildMetricCard(
                    'Taux engagement',
                    '78%',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildMetricCard(
                    'Revenus',
                    '2,450€',
                    Icons.euro,
                    AppColors.warning,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildMetricCard(
                    'Note moyenne',
                    '4.8',
                    Icons.star,
                    AppColors.secondary,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, end: 0, duration: 600.ms),
            SizedBox(height: AppSpacing.lg),

            // SECTION 2: GRAPHIQUE INSCRIPTIONS
            Text(
              'Inscriptions des 30 derniers jours',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildEnrollmentsChart()
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.lg),

            // SECTION 3: FRUSTRATION PAR COURS
            Text(
              'Frustration par cours',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildFrustrationChart()
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.lg),

            // SECTION 4: HEATMAP SESSIONS
            Text(
              'Moments d\'activité des étudiants',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildActivityHeatmap()
                .animate()
                .fadeIn(delay: 700.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.lg),

            // SECTION 5: TOP ÉTUDIANTS
            Text(
              'Top étudiants',
              style: AppTextStyles.h3,
            )
                .animate()
                .fadeIn(delay: 800.ms, duration: 600.ms),
            SizedBox(height: AppSpacing.md),
            _buildTopStudents()
                .animate()
                .fadeIn(delay: 900.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentsChart() {
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
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 5 == 0) {
                    return Text(
                      'J${value.toInt()}',
                      style: AppTextStyles.captionSmall,
                    );
                  }
                  return Text('');
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 5),
                FlSpot(1, 8),
                FlSpot(2, 6),
                FlSpot(3, 12),
                FlSpot(4, 15),
                FlSpot(5, 18),
                FlSpot(6, 20),
                FlSpot(7, 22),
                FlSpot(8, 19),
                FlSpot(9, 25),
                FlSpot(10, 28),
                FlSpot(11, 30),
                FlSpot(12, 27),
                FlSpot(13, 32),
                FlSpot(14, 35),
                FlSpot(15, 33),
                FlSpot(16, 38),
                FlSpot(17, 40),
                FlSpot(18, 37),
                FlSpot(19, 42),
                FlSpot(20, 45),
                FlSpot(21, 43),
                FlSpot(22, 48),
                FlSpot(23, 50),
                FlSpot(24, 47),
                FlSpot(25, 52),
                FlSpot(26, 55),
                FlSpot(27, 53),
                FlSpot(28, 58),
                FlSpot(29, 60),
              ],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: FlDotData(show: false),
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

  Widget _buildFrustrationChart() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
      ),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final courses = [
                    'Python',
                    'Flutter',
                    'ML',
                    'React',
                    'Vue',
                  ];
                  if (value.toInt() < courses.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        courses[value.toInt()],
                        style: AppTextStyles.captionSmall,
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 4.2,
                  color: AppColors.success,
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 6.5,
                  color: AppColors.warning,
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 8.3,
                  color: AppColors.error,
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: 3.8,
                  color: AppColors.success,
                  width: 16,
                ),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: 5.1,
                  color: AppColors.warning,
                  width: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityHeatmap() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Légende: Plus foncé = plus d\'activité',
            style: AppTextStyles.caption,
          ),
          SizedBox(height: AppSpacing.md),
          // Heatmap simplifié (7 jours x 24 heures serait trop dense)
          // On fait 7 jours x 4 périodes (matin, midi, après-midi, soir)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 28, // 7 jours x 4 périodes
            itemBuilder: (context, index) {
              final intensity = (index % 4) / 4.0; // Simulation
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2 + intensity * 0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopStudents() {
    final students = [
      {'name': 'Ahmed Mansouri', 'hours': 45, 'courses': 8},
      {'name': 'Fatima Alami', 'hours': 38, 'courses': 7},
      {'name': 'Youssef Benali', 'hours': 32, 'courses': 6},
      {'name': 'Aicha Idrissi', 'hours': 28, 'courses': 5},
      {'name': 'Omar Tazi', 'hours': 25, 'courses': 5},
    ];

    return Column(
      children: students.asMap().entries.map((entry) {
        final index = entry.key;
        final student = entry.value;
        return Container(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mediumAll,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rank
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: index < 3
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: index < 3 ? AppColors.warning : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              // Avatar
              CircleAvatar(
                radius: 18,
                child: Icon(Icons.person, size: 18),
              ),
              SizedBox(width: AppSpacing.sm),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student['name'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '${student['hours']}h étudiées',
                            style: AppTextStyles.caption.copyWith(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 12, color: AppColors.success),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '${student['courses']} cours complétés',
                            style: AppTextStyles.caption.copyWith(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(
              delay: (900 + index * 50).ms,
              duration: 600.ms,
            )
            .slideX(
              begin: -0.1,
              end: 0,
              delay: (900 + index * 50).ms,
              duration: 600.ms,
            );
      }).toList(),
    );
  }
}

