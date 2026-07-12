import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'How do I apply to an internship?',
      'Open an opportunity from Discover and tap Apply. You\'ll need a complete profile with at least your university, degree, and a short bio before applying.',
    ),
    (
      'How do startups see my application?',
      'Startups review applicants directly in their dashboard and can move your application through their hiring pipeline — Screening, Interview, Technical Assessment, Offer.',
    ),
    (
      'How do I know if I have an interview scheduled?',
      'Check the Upcoming Interviews section on your profile — it shows the date, time, location, and meeting link for any interview a startup has scheduled with you.',
    ),
    (
      'Can I withdraw an application?',
      'Not directly yet — message the startup through Messages if you need to withdraw.',
    ),
    (
      'How do I update my resume or portfolio links?',
      'Go to your Profile and use the Resume and Portfolio & Links sections to upload or update them at any time.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Frequently Asked Questions', style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.md),
          for (final faq in _faqs) ...[
            _FaqTile(question: faq.$1, answer: faq.$2),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Still need help?', style: AppTextStyles.titleSmall),
                const SizedBox(height: 6),
                Text(
                  'Reach out and we\'ll get back to you as soon as we can.',
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: 'support@aluconnect.app',
                      query: 'subject=ALU Connect Support',
                    ),
                  ),
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Contact support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: ExpansionTile(
        title: Text(question, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(answer, style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }
}
