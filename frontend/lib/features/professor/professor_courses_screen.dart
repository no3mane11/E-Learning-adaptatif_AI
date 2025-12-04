import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../shared/widgets/buttons/primary_button.dart';

/// Écran de gestion des cours (professeur)
class ProfessorCoursesScreen extends StatelessWidget {
  const ProfessorCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes cours'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Créer un nouveau cours
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un cours...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Courses list
          Expanded(
            child: _buildCoursesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(BuildContext context) {
    // TODO: Récupérer les cours depuis l'API
    final courses = <Map<String, dynamic>>[]; // Mock data

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucun cours',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              onPressed: () {
                // TODO: Créer un cours
              },
              label: 'Créer un cours',
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _buildCourseCard(context, courses[index])
            .animate()
            .fadeIn(
              delay: (index * 50).ms,
              duration: 600.ms,
            )
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

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] ?? 'Titre du cours',
                      style: AppTextStyles.h4,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '${course['studentCount'] ?? 0} étudiants',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Éditer'),
                    onTap: () {
                      // TODO: Éditer le cours
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Supprimer'),
                    onTap: () {
                      // TODO: Supprimer le cours
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Voir les détails
                  },
                  child: Text('Détails'),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/professor/analytics');
                  },
                  child: Text('Analyses'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



