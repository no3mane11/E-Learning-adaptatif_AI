import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/buttons/button_size.dart';
import '../../shared/models/course_model.dart';
import '../../shared/models/lesson_model.dart';

/// Écran de détails d'un cours
class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  CourseModel? _course;
  List<LessonModel> _lessons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseDetails();
  }

  Future<void> _loadCourseDetails() async {
    // TODO: Charger les détails du cours depuis l'API
    // Mock data pour tester
    await Future.delayed(Duration(milliseconds: 500));
    
    setState(() {
      _course = CourseModel(
        id: widget.courseId,
        title: 'Introduction à Flutter',
        description: 'Apprenez les bases de Flutter et développez vos premières applications mobiles. Ce cours vous guidera à travers les concepts fondamentaux du framework Flutter, du développement d\'interfaces utilisateur à la gestion d\'état.',
        thumbnail: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&h=600&fit=crop',
        instructorId: 'instructor-1',
        instructorName: 'Jean Dupont',
        categories: ['Développement'],
        lessonCount: 12,
        studentCount: 234,
        rating: 4.7,
        level: 'beginner',
      );
      
      _lessons = [
        LessonModel(
          id: 'lesson-1',
          courseId: widget.courseId,
          title: 'Introduction à Flutter',
          description: 'Découvrez Flutter et son écosystème',
          duration: 600, // 10 minutes
          order: 1,
        ),
        LessonModel(
          id: 'lesson-2',
          courseId: widget.courseId,
          title: 'Installation et Configuration',
          description: 'Installez Flutter et configurez votre environnement de développement',
          duration: 900, // 15 minutes
          order: 2,
        ),
        LessonModel(
          id: 'lesson-3',
          courseId: widget.courseId,
          title: 'Première Application',
          description: 'Créez votre première application Flutter',
          duration: 1200, // 20 minutes
          order: 3,
        ),
      ];
      
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_course == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Cours non trouvé'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar avec image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: _course!.thumbnail != null
                    ? Image.network(
                        _course!.thumbnail!,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
          // Content
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title
                Text(
                  _course!.title,
                  style: AppTextStyles.h1,
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms),
                SizedBox(height: AppSpacing.sm),
                // Instructor
                if (_course!.instructorName != null)
                  Text(
                    'Par ${_course!.instructorName}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 600.ms),
                SizedBox(height: AppSpacing.md),
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStat(Icons.star, _course!.rating.toStringAsFixed(1)),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildStat(
                        Icons.play_circle,
                        '${_course!.lessonCount} leçons',
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildStat(
                        Icons.people,
                        '${_course!.studentCount} étudiants',
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms),
                SizedBox(height: AppSpacing.xl),
                // Description
                Text(
                  'Description',
                  style: AppTextStyles.h3,
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms),
                SizedBox(height: AppSpacing.sm),
                Text(
                  _course!.description,
                  style: AppTextStyles.body,
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms),
                SizedBox(height: AppSpacing.xl),
                // Lessons
                Text(
                  'Leçons (${_lessons.length})',
                  style: AppTextStyles.h3,
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms),
                SizedBox(height: AppSpacing.md),
                ..._lessons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lesson = entry.value;
                  return _buildLessonItem(lesson, index + 1)
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
                }),
                SizedBox(height: AppSpacing.xxl),
                // Start button
                PrimaryButton(
                  onPressed: () {
                    if (_lessons.isNotEmpty) {
                      context.push('/lesson/${_lessons.first.id}?courseId=${widget.courseId}');
                    }
                  },
                  label: 'Commencer le cours',
                  size: ButtonSize.large,
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 600.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .scale(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildLessonItem(LessonModel lesson, int number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/lesson/${lesson.id}?courseId=${widget.courseId}'),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Number avec gradient
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: lesson.isCompleted
                      ? LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                        )
                      : LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (lesson.isCompleted
                              ? Color(0xFF4CAF50)
                              : Color(0xFF667EEA))
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                  child: Center(
                  child: lesson.isCompleted
                      ? Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 24,
                        )
                      : Text(
                          '$number',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (lesson.isCompleted)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Terminé',
                                  style: AppTextStyles.captionSmall.copyWith(
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      lesson.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${(lesson.duration / 60).toStringAsFixed(0)} min',
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              // Arrow icon
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(delay: 100.ms, duration: 300.ms)
                  .shimmer(delay: 200.ms, duration: 1000.ms),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 100.ms, duration: 400.ms)
        .slideX(begin: -0.1, end: 0, delay: 100.ms, duration: 400.ms);
  }
}

