import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: RadioListTile<String>(
              value: 'en',
              // ignore: deprecated_member_use
              groupValue: 'en',
              title: const Text('English'),
              subtitle: const Text('Default'),
              // ignore: deprecated_member_use
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'More languages are coming soon. ALU Connect is currently only available in English.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textHint),
          ),
        ],
      ),
    );
  }
}
