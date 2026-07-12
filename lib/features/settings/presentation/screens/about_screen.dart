import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colors.info.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.school_outlined, size: 36, color: colors.info),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(AppConstants.appName, style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Version ${AppConstants.appVersion}',
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'ALU Connect helps African Leadership University students find internships and other opportunities with startups, '
            'and helps startups discover, evaluate, and hire student talent — from application through offer.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                const _AboutRow(label: 'Terms of Service'),
                Divider(height: 1, color: colors.divider),
                const _AboutRow(label: 'Privacy Policy'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              '© ${DateTime.now().year} ALU Connect',
              style: AppTextStyles.caption.copyWith(color: colors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      title: Text(label, style: AppTextStyles.bodyMedium),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colors.textHint),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Coming soon.')),
        );
      },
    );
  }
}
