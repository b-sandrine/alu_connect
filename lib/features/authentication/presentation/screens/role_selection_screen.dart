import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../domain/entities/user_entity.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GradientHeader(
              roundedBottom: true,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join ALU Connect',
                    style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.15, end: 0),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'How will you use ALU Connect?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 60.ms).slideY(begin: 0.15, end: 0),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RoleCard(
                      role: UserRole.student,
                      title: 'I am a Student',
                      subtitle: 'Discover opportunities, apply to startups, and grow your career.',
                      icon: Icons.school_outlined,
                      color: colors.studentAccent,
                      onTap: () => context.push('/register', extra: UserRole.student),
                    ).animate().fadeIn(duration: 300.ms, delay: 120.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    _RoleCard(
                      role: UserRole.startup,
                      title: 'I represent a Startup',
                      subtitle: 'Post opportunities, review applications, and find top talent.',
                      icon: Icons.business_outlined,
                      color: colors.startupAccent,
                      onTap: () => context.push('/register', extra: UserRole.startup),
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Sign in'),
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

class _RoleCard extends StatefulWidget {
  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.color.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'role-icon-${widget.role.name}',
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 28),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.titleMedium.copyWith(color: colors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: widget.color),
            ],
          ),
        ),
      ),
    );
  }
}
