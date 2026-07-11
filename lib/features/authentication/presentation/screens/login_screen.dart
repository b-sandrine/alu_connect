import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../providers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    final error = ref.read(authControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final colors = context.colors;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GradientHeader(
              roundedBottom: true,
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'app-logo',
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.connect_without_contact,
                            color: Color(0xFF1A73E8),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ALU Connect',
                        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Welcome back',
                    style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.15, end: 0),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Sign in to your account',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 60.ms).slideY(begin: 0.15, end: 0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Email address',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                    ).animate().fadeIn(duration: 300.ms, delay: 120.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outlined,
                      validator: (v) => Validators.required(v, fieldName: 'Password'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _signIn(),
                    ).animate().fadeIn(duration: 300.ms, delay: 160.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: 'Sign in',
                      onPressed: _signIn,
                      isLoading: isLoading,
                      useGradient: true,
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/role-selection'),
                          child: const Text('Sign up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
