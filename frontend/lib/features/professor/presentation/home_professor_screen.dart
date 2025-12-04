import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import 'widgets/stat_card.dart';
import 'widgets/student_alert_card.dart';

/// Dashboard principal pour les professeurs
class HomeProfessorScreen extends StatefulWidget {
  const HomeProfessorScreen({super.key});

  @override
  State<HomeProfessorScreen> createState() => _HomeProfessorScreenState();
}

class _HomeProfessorScreenState extends State<HomeProfessorScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToStudents() {
    _scrollController.animateTo(
      800, // Position approximative de la section étudiants
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Rafraîchir les données
          await Future.delayed(Duration(seconds: 1));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // SECTION 1: HEADER / APP BAR
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          // Nom
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bienvenue 👨‍🏫',
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  'Prof. Ahmed Mansouri',
                                  style: AppTextStyles.h3.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Notifications
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.notifications_outlined),
                                color: Colors.white,
                                onPressed: () {
                                  // TODO: Naviguer vers notifications
                                },
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Settings
                          IconButton(
                            icon: Icon(Icons.settings_outlined),
                            color: Colors.white,
                            onPressed: () {
                              // TODO: Naviguer vers paramètres
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // SECTION 2: STATISTIQUES RAPIDES
            SliverPadding(
              padding: EdgeInsets.all(AppSpacing.sm),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.15,
                ),
                delegate: SliverChildListDelegate([
                  StatCard(
                    icon: Icons.book_outlined,
                    value: '12',
                    label: 'Cours créés',
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    trend: '+2 ce mois',
                    onTap: () => context.push('/professor/courses'),
                  ).animate().fadeIn(delay: 0.ms, duration: 600.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 0.ms,
                        duration: 600.ms,
                      ),
                  StatCard(
                    icon: Icons.people_outline,
                    value: '347',
                    label: 'Étudiants inscrits',
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                    trend: '+23 cette semaine',
                  ).animate().fadeIn(delay: 100.ms, duration: 600.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 100.ms,
                        duration: 600.ms,
                      ),
                  StatCard(
                    icon: Icons.check_circle_outline,
                    value: '68%',
                    label: 'Taux de complétion',
                    gradient: LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    progress: 0.68,
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 200.ms,
                        duration: 600.ms,
                      ),
                  StatCard(
                    icon: Icons.warning_amber_rounded,
                    value: '15',
                    label: 'Étudiants bloqués',
                    gradient: LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                    ),
                    onTap: _scrollToStudents,
                  ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 300.ms,
                        duration: 600.ms,
                      ),
                ]),
              ),
            ),

            // SECTION 3: ACTIONS RAPIDES
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.book_outlined,
                        title: 'Gérer mes cours',
                        subtitle: 'Créer, modifier, supprimer',
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ),
                        onTap: () => context.push('/professor/courses'),
                      ).animate().fadeIn(delay: 400.ms, duration: 600.ms).scale(
                            begin: Offset(0.9, 0.9),
                            end: Offset(1.0, 1.0),
                            delay: 400.ms,
                            duration: 600.ms,
                          ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.bar_chart,
                        title: 'Tableau de bord',
                        subtitle: 'Stats & Analytics',
                        gradient: LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
                        ),
                        onTap: () => context.push('/professor/analytics'),
                      ).animate().fadeIn(delay: 500.ms, duration: 600.ms).scale(
                            begin: Offset(0.9, 0.9),
                            end: Offset(1.0, 1.0),
                            delay: 500.ms,
                            duration: 600.ms,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),

            // SECTION 4: ÉTUDIANTS EN DIFFICULTÉ
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Étudiants nécessitant attention',
                                  style: AppTextStyles.h3,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '15',
                                  style: AppTextStyles.captionSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        TextButton(
                          onPressed: () {
                            // TODO: Naviguer vers liste complète
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xs,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Voir tout',
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Liste étudiants
                    ...List.generate(
                      5,
                      (index) => StudentAlertCard(
                        studentName: 'Ahmed Mansouri',
                        courseName: 'Introduction Python',
                        frustrationScore: 8.5,
                        lastSession: 'Il y a 2h',
                        onContact: () {
                          // TODO: Ouvrir chat/email
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Contacter ${'Ahmed Mansouri'}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Déjà sur home
              break;
            case 1:
              context.push('/professor/courses');
              break;
            case 2:
              context.push('/professor/analytics');
              break;
            case 3:
              // TODO: Messages
              break;
            case 4:
              context.push('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Mes Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: AppRadius.largeAll,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2),
            Flexible(
              child: Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .scale(
          begin: Offset(1.0, 1.0),
          end: Offset(0.95, 0.95),
          duration: 100.ms,
        )
        .then()
        .scale(
          begin: Offset(0.95, 0.95),
          end: Offset(1.0, 1.0),
          duration: 100.ms,
        );
  }
}
