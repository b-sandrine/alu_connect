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
import '../../domain/entities/user_entity.dart';
import '../providers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, required this.role});

  final UserRole role;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
          role: widget.role,
        );

    if (!mounted) return;

    final error = ref.read(authControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
    }
  }

  String get _roleLabel =>
      widget.role == UserRole.student ? 'Student' : 'Startup';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final colors = context.colors;
    final roleColor =
        widget.role == UserRole.student ? colors.studentAccent : colors.startupAccent;
    final roleIcon =
        widget.role == UserRole.student ? Icons.school_outlined : Icons.business_outlined;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            roundedBottom: true,
            padding: const EdgeInsets.fromLTRB(24, 96, 24, 32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'role-icon-${widget.role.name}',
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(roleIcon, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$_roleLabel account',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your account',
                      style: AppTextStyles.displayMedium.copyWith(color: colors.textPrimary),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Fill in your details to get started',
                      style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
                    ).animate().fadeIn(duration: 300.ms, delay: 60.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xxl),
                    AppTextField(
                      label: widget.role == UserRole.student ? 'Full name' : 'Your name',
                      hint: 'Enter your name',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: (v) => Validators.minLength(v, 2, fieldName: 'Name'),
                      textInputAction: TextInputAction.next,
                    ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Email address',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                    ).animate().fadeIn(duration: 300.ms, delay: 140.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outlined,
                      validator: Validators.password,
                      textInputAction: TextInputAction.next,
                    ).animate().fadeIn(duration: 300.ms, delay: 180.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Confirm password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outlined,
                      validator: (v) => Validators.confirmPassword(
                        v,
                        _passwordController.text,
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _register(),
                    ).animate().fadeIn(duration: 300.ms, delay: 220.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: 'Create account',
                      onPressed: _register,
                      isLoading: isLoading,
                      useGradient: true,
                    ).animate().fadeIn(duration: 300.ms, delay: 260.ms),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Text(
                        'By creating an account, you agree to our Terms of Service.',
                        style: AppTextStyles.caption.copyWith(color: colors.textHint),
                        textAlign: TextAlign.center,
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
}
