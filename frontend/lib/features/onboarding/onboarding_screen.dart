import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/buttons/button_size.dart';

/// Écran d'onboarding avec pages multiples
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bienvenue !',
      description:
          'Découvrez une nouvelle façon d\'apprendre avec notre plateforme intelligente.',
      icon: Icons.school,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Apprentissage Personnalisé',
      description:
          'Notre IA adapte le contenu à votre rythme et votre style d\'apprentissage.',
      icon: Icons.psychology,
      color: AppColors.secondary,
    ),
    OnboardingPage(
      title: 'Suivi des Émotions',
      description:
          'Nous analysons votre engagement pour améliorer votre expérience d\'apprentissage.',
      icon: Icons.sentiment_satisfied,
      color: AppColors.success,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await StorageService.instance.setOnboardingCompleted(true);
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Passer',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            // Indicators & Button
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index == _currentPage),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  // Next button
                  PrimaryButton(
                    onPressed: _nextPage,
                    label: _currentPage == _pages.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    size: ButtonSize.large,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 100,
              color: page.color,
            ),
          )
              .animate()
              .scale(
                delay: 100.ms,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(
                delay: 100.ms,
                duration: 600.ms,
              ),
          SizedBox(height: AppSpacing.xxl),
          // Title
          Text(
            page.title,
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                delay: 300.ms,
                duration: 600.ms,
              )
              .slideY(
                begin: 0.2,
                end: 0,
                delay: 300.ms,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
          SizedBox(height: AppSpacing.md),
          // Description
          Text(
            page.description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                delay: 500.ms,
                duration: 600.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .scale(duration: 300.ms, curve: Curves.easeInOut);
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

