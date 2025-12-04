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

/// Écran d'inscription
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'student';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.instance.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
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
        result['error'] ?? 'Erreur d\'inscription',
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.lg),
                Text(
                  'Créer un compte',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(
                      delay: 100.ms,
                      duration: 600.ms,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: 100.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Rejoignez-nous pour commencer',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
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
                      delay: 250.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.lg),
                // First name
                TextInput(
                  label: 'Prénom',
                  hint: 'Jean',
                  controller: _firstNameController,
                  validator: (v) => Validators.required(v, fieldName: 'Le prénom'),
                  prefixIcon: Icon(Icons.person_outline),
                )
                    .animate()
                    .fadeIn(
                      delay: 350.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Last name
                TextInput(
                  label: 'Nom',
                  hint: 'Dupont',
                  controller: _lastNameController,
                  validator: (v) => Validators.required(v, fieldName: 'Le nom'),
                  prefixIcon: Icon(Icons.person_outline),
                )
                    .animate()
                    .fadeIn(
                      delay: 450.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Email
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
                      delay: 550.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Password
                TextInput(
                  label: 'Mot de passe',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  prefixIcon: Icon(Icons.lock_outline),
                )
                    .animate()
                    .fadeIn(
                      delay: 650.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Confirm password
                TextInput(
                  label: 'Confirmer le mot de passe',
                  hint: '••••••••',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (v) => Validators.confirmPassword(
                    v,
                    _passwordController.text,
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSignup(),
                )
                    .animate()
                    .fadeIn(
                      delay: 750.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.xl),
                // Signup button
                PrimaryButton(
                  onPressed: _handleSignup,
                  label: 'S\'inscrire',
                  isLoading: _isLoading,
                  size: ButtonSize.large,
                )
                    .animate()
                    .fadeIn(
                      delay: 850.ms,
                      duration: 600.ms,
                    ),
                SizedBox(height: AppSpacing.md),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Se connecter',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(
                      delay: 950.ms,
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

