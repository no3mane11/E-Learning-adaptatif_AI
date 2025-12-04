import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/cards/course_card.dart';
import '../../shared/models/course_model.dart';

/// Écran de liste des cours avec design moderne
class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Tous';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tous', 'icon': Icons.apps_rounded},
    {'name': 'Développement', 'icon': Icons.code_rounded},
    {'name': 'Design', 'icon': Icons.palette_rounded},
    {'name': 'Business', 'icon': Icons.business_center_rounded},
    {'name': 'Marketing', 'icon': Icons.trending_up_rounded},
    {'name': 'Langues', 'icon': Icons.language_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // AppBar moderne avec gradient
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.xl,
                      bottom: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .scale(delay: 100.ms),
                            Expanded(
                              child: Text(
                                'Cours',
                                style: AppTextStyles.h1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: 200.ms, duration: 600.ms)
                                  .slideX(begin: -0.2, end: 0),
                            ),
                            IconButton(
                              icon: Icon(Icons.filter_list_rounded, color: Colors.white),
                              onPressed: () {},
                            )
                                .animate()
                                .fadeIn(delay: 300.ms, duration: 600.ms)
                                .scale(delay: 300.ms),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Search bar moderne
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un cours...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF667EEA)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: -0.1, end: 0, delay: 200.ms),
            ),
          ),
          // Categories avec design moderne
          SliverToBoxAdapter(
            child: SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category['name'] == _selectedCategory;
                  return Padding(
                    padding: EdgeInsets.only(right: AppSpacing.sm),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category['name'] as String;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                  )
                                : null,
                            color: isSelected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Color(0xFF667EEA).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category['icon'] as IconData,
                                color: isSelected ? Colors.white : Color(0xFF667EEA),
                                size: 20,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                category['name'] as String,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: (300 + index * 50).ms, duration: 400.ms)
                        .scale(delay: (300 + index * 50).ms, duration: 400.ms),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md).sliver,
          // Courses list
          _buildCoursesList(),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    final courses = <CourseModel>[
      CourseModel(
        id: 'course-1',
        title: 'Introduction à Flutter',
        description: 'Apprenez les bases de Flutter et développez vos premières applications mobiles.',
        thumbnail: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&h=600&fit=crop',
        instructorId: 'instructor-1',
        instructorName: 'Jean Dupont',
        categories: ['Développement'],
        lessonCount: 12,
        studentCount: 234,
        rating: 4.7,
        level: 'beginner',
      ),
      CourseModel(
        id: 'course-2',
        title: 'UI/UX Design Moderne',
        description: 'Créez des interfaces utilisateur magnifiques et intuitives.',
        thumbnail: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800&h=600&fit=crop',
        instructorId: 'instructor-2',
        instructorName: 'Marie Martin',
        categories: ['Design'],
        lessonCount: 8,
        studentCount: 156,
        rating: 4.9,
        level: 'intermediate',
      ),
      CourseModel(
        id: 'course-3',
        title: 'Marketing Digital',
        description: 'Maîtrisez les stratégies de marketing digital et les réseaux sociaux.',
        thumbnail: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&h=600&fit=crop',
        instructorId: 'instructor-3',
        instructorName: 'Pierre Durand',
        categories: ['Marketing', 'Business'],
        lessonCount: 15,
        studentCount: 421,
        rating: 4.5,
        level: 'beginner',
      ),
      CourseModel(
        id: 'course-4',
        title: 'Python pour Débutants',
        description: 'Découvrez la programmation Python étape par étape.',
        thumbnail: 'https://images.unsplash.com/photo-1526374965328-7f61d4f18cc5?w=800&h=600&fit=crop',
        instructorId: 'instructor-4',
        instructorName: 'Sophie Bernard',
        categories: ['Développement'],
        lessonCount: 20,
        studentCount: 567,
        rating: 4.8,
        level: 'beginner',
      ),
    ];

    if (courses.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: Color(0xFF667EEA),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: Offset(1.0, 1.0),
                    end: Offset(1.1, 1.1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Aucun cours trouvé',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.1, end: 0, delay: 200.ms),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: CourseCard(
                course: courses[index],
                onTap: () => context.push('/course/${courses[index].id}'),
              )
                  .animate()
                  .fadeIn(
                    delay: (index * 100).ms,
                    duration: 600.ms,
                  )
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    delay: (index * 100).ms,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .shimmer(
                    delay: (index * 100 + 300).ms,
                    duration: 1000.ms,
                  ),
            );
          },
          childCount: courses.length,
        ),
      ),
    );
  }
}

// Extension pour convertir Widget en Sliver
extension SliverExtension on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);
}
