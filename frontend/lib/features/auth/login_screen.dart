import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/helpers.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/buttons/button_size.dart';
import '../../shared/widgets/inputs/text_input.dart';
import '../../shared/widgets/role_selector.dart';

/// Écran de connexion
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'student';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.instance.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result['success'] == true) {
      // Rediriger selon le rôle
      final userRole = result['user']?['role'] ?? _selectedRole;
      if (userRole == 'professor') {
        context.go('/professor');
      } else {
        context.go('/home');
      }
    } else {
      Helpers.showSnackBar(
        context,
        result['error'] ?? 'Erreur de connexion',
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xxl),
                // Logo/Title
                Icon(
                  Icons.school,
                  size: 64,
                  color: AppColors.primary,
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
                SizedBox(height: AppSpacing.lg),
                Text(
                  'Connexion',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
                      duration: 600.ms,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: 200.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Connectez-vous pour continuer',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(
                      delay: 300.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.xxl),
                // Role selector
                RoleSelector(
                  selectedRole: _selectedRole,
                  onRoleChanged: (role) {
                    setState(() {
                      _selectedRole = role;
                    });
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: 350.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.lg),
                // Email input
                TextInput(
                  label: 'Email',
                  hint: 'votre@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  prefixIcon: Icon(Icons.email_outlined),
                )
                    .animate()
                    .fadeIn(
                      delay: 450.ms,
                      duration: 600.ms,
                    )
                    .slideX(
                      begin: -0.1,
                      end: 0,
                      delay: 450.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: AppSpacing.md),
                // Password input
                TextInput(
                  label: 'Mot de passe',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  prefixIcon: Icon(Icons.lock_outline),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                )
                    .animate()
                    .fadeIn(
                      delay: 550.ms,
                      duration: 600.ms,
                    )
                    .slideX(
                      begin: -0.1,
                      end: 0,
                      delay: 550.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: AppSpacing.sm),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implémenter réinitialisation mot de passe
                    },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                // Login button
                PrimaryButton(
                  onPressed: _handleLogin,
                  label: 'Se connecter',
                  isLoading: _isLoading,
                  size: ButtonSize.large,
                )
                    .animate()
                    .fadeIn(
                      delay: 650.ms,
                      duration: 600.ms,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: 650.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: AppSpacing.md),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore de compte ? ',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(
                        'S\'inscrire',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      delay: 750.ms,
                      duration: 600.ms,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

