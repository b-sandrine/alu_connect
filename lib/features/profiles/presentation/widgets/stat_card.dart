import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.delay = Duration.zero,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text('$value', style: AppTextStyles.displayMedium.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay).slideY(begin: 0.15, end: 0);
  }
}
