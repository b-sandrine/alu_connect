import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_header.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.step,
  });

  final String title;
  final String subtitle;
  final String step;

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      roundedBottom: true,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
          ).animate().fadeIn(duration: 350.ms, delay: 60.ms).slideY(begin: 0.15, end: 0),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ).animate().fadeIn(duration: 350.ms, delay: 120.ms).slideY(begin: 0.15, end: 0),
        ],
      ),
    );
  }
}
