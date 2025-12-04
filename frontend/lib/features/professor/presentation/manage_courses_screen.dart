import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/helpers.dart';

/// Écran de gestion des cours pour professeur
class ManageCoursesScreen extends StatefulWidget {
  const ManageCoursesScreen({super.key});

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<CourseItem> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    // TODO: Charger depuis l'API
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      _courses = [
        CourseItem(
          id: '1',
          title: 'Introduction à Python',
          thumbnail: null,
          enrolledCount: 234,
          rating: 4.7,
          publishedDate: DateTime.now().subtract(Duration(days: 15)),
          isPublished: true,
        ),
        CourseItem(
          id: '2',
          title: 'Flutter Avancé',
          thumbnail: null,
          enrolledCount: 156,
          rating: 4.9,
          publishedDate: DateTime.now().subtract(Duration(days: 5)),
          isPublished: true,
        ),
        CourseItem(
          id: '3',
          title: 'Machine Learning Basics',
          thumbnail: null,
          enrolledCount: 0,
          rating: 0.0,
          publishedDate: null,
          isPublished: false,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Cours'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Naviguer vers création cours
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Créer un nouveau cours')),
              );
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
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un cours...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          // TODO: Ouvrir bottom sheet filtres
                        },
                      ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          // Liste des cours
          Expanded(
            child: _buildCoursesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Naviguer vers création cours
        },
        icon: Icon(Icons.add),
        label: Text('Nouveau cours'),
      ),
    );
  }

  Widget _buildCoursesList() {
    if (_isLoading) {
      return ListView.builder(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: 3,
        itemBuilder: (context, index) => _buildSkeletonCard(),
      );
    }

    if (_courses.isEmpty) {
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
              'Aucun cours créé',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Créer cours
              },
              icon: Icon(Icons.add),
              label: Text('Créer mon premier cours'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        return _buildCourseCard(_courses[index])
            .animate()
            .fadeIn(
              delay: (index * 100).ms,
              duration: 600.ms,
            )
            .slideX(
              begin: 0.1,
              end: 0,
              delay: (index * 100).ms,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildCourseCard(CourseItem course) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeAll,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppRadius.mediumAll,
            ),
            child: course.thumbnail != null
                ? ClipRRect(
                    borderRadius: AppRadius.mediumAll,
                    child: Image.network(
                      course.thumbnail!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.book,
                    size: 40,
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
                  course.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.people, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '${course.enrolledCount} inscrits',
                      style: AppTextStyles.caption,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Icon(Icons.star, size: 14, color: AppColors.warning),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      course.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  course.publishedDate != null
                      ? 'Publié le ${Helpers.formatDate(course.publishedDate!)}'
                      : 'Brouillon',
                  style: AppTextStyles.captionSmall,
                ),
                SizedBox(height: AppSpacing.xs),
                // Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: course.isPublished
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    course.isPublished ? 'Publié' : 'Brouillon',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: course.isPublished
                          ? AppColors.success
                          : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                color: AppColors.primary,
                onPressed: () {
                  // TODO: Éditer cours
                  context.push('/professor/courses/${course.id}/edit');
                },
              ),
              IconButton(
                icon: Icon(Icons.bar_chart_outlined),
                color: AppColors.secondary,
                onPressed: () {
                  // TODO: Stats cours
                  context.push('/professor/courses/${course.id}/stats');
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                color: AppColors.error,
                onPressed: () => _confirmDelete(course),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.largeAll,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(CourseItem course) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Supprimer le cours',
      message: 'Êtes-vous sûr de vouloir supprimer "${course.title}" ? Cette action est irréversible.',
      confirmText: 'Supprimer',
      cancelText: 'Annuler',
    );

    if (confirmed) {
      // TODO: Supprimer depuis l'API
      setState(() {
        _courses.removeWhere((c) => c.id == course.id);
      });
      Helpers.showSnackBar(
        context,
        'Cours supprimé',
        backgroundColor: AppColors.success,
      );
    }
  }
}

class CourseItem {
  final String id;
  final String title;
  final String? thumbnail;
  final int enrolledCount;
  final double rating;
  final DateTime? publishedDate;
  final bool isPublished;

  CourseItem({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.enrolledCount,
    required this.rating,
    this.publishedDate,
    required this.isPublished,
  });
}



