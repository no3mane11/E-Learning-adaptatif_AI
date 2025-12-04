import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/auth_service.dart';

/// Écran de démarrage avec animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialiser les services
    await StorageService.instance.init();
    await AuthService.instance.init();

    // Attendre un minimum pour l'animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Vérifier si l'onboarding est complété
    final onboardingCompleted =
        StorageService.instance.isOnboardingCompleted() ?? false;

    if (!onboardingCompleted) {
      context.go('/onboarding');
      return;
    }

    // Vérifier si l'utilisateur est connecté
    final isAuthenticated = await AuthService.instance.isAuthenticated();

    if (isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.textInverse,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.overlay,
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school,
                  size: 64,
                  color: AppColors.primary,
                ),
              )
                  .animate()
                  .scale(
                    delay: 200.ms,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(
                    delay: 200.ms,
                    duration: 600.ms,
                  ),
              SizedBox(height: 32),
              // App Name
              Text(
                'E-Learning',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.textInverse,
                  fontSize: 32,
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: 400.ms,
                    duration: 600.ms,
                  )
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    delay: 400.ms,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  ),
              SizedBox(height: 8),
              Text(
                'Apprenez avec intelligence',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textInverse.withOpacity(0.9),
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: 600.ms,
                    duration: 600.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}



