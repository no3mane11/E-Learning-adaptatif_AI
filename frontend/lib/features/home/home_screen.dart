import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/cards/course_card.dart';
import '../../shared/models/course_model.dart';

/// Écran d'accueil étudiant avec design moderne
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // App Bar avec gradient moderne
            SliverAppBar(
              expandedHeight: 180,
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
                  child: Stack(
                    children: [
                      // Effet de particules animées
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ParticlePainter(),
                        ),
                      ),
                      // Contenu
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          top: AppSpacing.xxl,
                          bottom: AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bonjour ! 👋',
                                      style: AppTextStyles.h1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                        .animate()
                                        .fadeIn(duration: 600.ms)
                                        .slideX(begin: -0.2, end: 0),
                                    SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Prêt à apprendre aujourd\'hui ?',
                                      style: AppTextStyles.body.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    )
                                        .animate()
                                        .fadeIn(delay: 200.ms, duration: 600.ms)
                                        .slideX(begin: -0.2, end: 0),
                                  ],
                                ),
                                // Avatar avec animation
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Colors.white70],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xFF667EEA),
                                    size: 32,
                                  ),
                                )
                                    .animate()
                                    .scale(delay: 300.ms, duration: 600.ms)
                                    .shimmer(delay: 400.ms, duration: 1000.ms),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // Badge notification avec animation
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .scale(
                            begin: Offset(1.0, 1.0),
                            end: Offset(1.3, 1.3),
                            duration: 1000.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .scale(delay: 400.ms),
                IconButton(
                  icon: Icon(Icons.person_outline, color: Colors.white),
                  onPressed: () => context.push('/profile'),
                )
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .scale(delay: 500.ms),
                SizedBox(width: AppSpacing.sm),
              ],
            ),
            // Content
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Bouton de test caméra avec design moderne
                  _buildModernButton(
                    icon: Icons.camera_alt_rounded,
                    label: '🧪 Tester la Caméra',
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    onTap: () => context.push('/lesson/lesson-1?courseId=course-1'),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.1, end: 0, duration: 600.ms)
                      .shimmer(delay: 200.ms, duration: 1500.ms),
                  SizedBox(height: AppSpacing.md),
                  // Stats Cards avec design moderne
                  _buildModernStatsSection()
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0, delay: 100.ms, duration: 600.ms),
                  SizedBox(height: AppSpacing.lg),
                  // Continue Learning avec header moderne
                  _buildModernSectionHeader(
                    'Continuer l\'apprentissage',
                    Icons.play_circle_filled_rounded,
                    () => context.push('/courses'),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideX(begin: -0.1, end: 0, delay: 200.ms),
                  SizedBox(height: AppSpacing.sm),
                  _buildContinueLearningSection()
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0, delay: 300.ms),
                  SizedBox(height: AppSpacing.lg),
                  // Recommended Courses avec header moderne
                  _buildModernSectionHeader(
                    'Cours recommandés',
                    Icons.star_rounded,
                    () => context.push('/courses'),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideX(begin: -0.1, end: 0, delay: 400.ms),
                  SizedBox(height: AppSpacing.sm),
                  _buildRecommendedCourses()
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0, delay: 500.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667EEA).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildModernStatCard(
            'Cours',
            '12',
            Icons.book_rounded,
            LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            0,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildModernStatCard(
            'Leçons',
            '45',
            Icons.play_circle_rounded,
            LinearGradient(
              colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
            ),
            100,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildModernStatCard(
            'Streak',
            '7',
            Icons.local_fire_department_rounded,
            LinearGradient(
              colors: [Color(0xFFFAD961), Color(0xFFF76B1C)],
            ),
            200,
          ),
        ),
      ],
    );
  }

  Widget _buildModernStatCard(
    String label,
    String value,
    IconData icon,
    Gradient gradient,
    int delay,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          )
              .animate()
              .scale(delay: delay.ms, duration: 400.ms)
              .shimmer(delay: (delay + 200).ms, duration: 1000.ms),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
              .animate()
              .fadeIn(delay: (delay + 100).ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0, delay: (delay + 100).ms),
          SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSectionHeader(
    String title,
    IconData icon,
    VoidCallback onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSeeAll,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Voir tout',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Color(0xFF667EEA),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueLearningSection() {
    final courses = <CourseModel>[];

    if (courses.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Color(0xFFF5F7FA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 48,
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
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucun cours en cours',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Commencez votre parcours d\'apprentissage',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/courses'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.explore_rounded, color: Colors.white, size: 20),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Explorer les cours',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(right: AppSpacing.md),
            child: CourseCard(
              course: courses[index],
              onTap: () => context.push('/course/${courses[index].id}'),
            ),
          )
              .animate()
              .fadeIn(delay: (index * 100).ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0, delay: (index * 100).ms, duration: 600.ms);
        },
      ),
    );
  }

  Widget _buildRecommendedCourses() {
    final courses = <CourseModel>[];

    if (courses.isEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.75,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
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
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: (index * 100).ms, duration: 600.ms)
              .scale(delay: (index * 100).ms, duration: 600.ms);
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(
          course: courses[index],
          onTap: () => context.push('/course/${courses[index].id}'),
        )
            .animate()
            .fadeIn(delay: (index * 100).ms, duration: 600.ms)
            .scale(delay: (index * 100).ms, duration: 600.ms);
      },
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: Color(0xFF667EEA).withOpacity(0.1),
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/courses');
              break;
            case 2:
              context.push('/history');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Historique',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Painter pour effet de particules animées
class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dessiner des cercles animés
    for (int i = 0; i < 20; i++) {
      final x = (i * 50.0) % size.width;
      final y = (i * 30.0) % size.height;
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
