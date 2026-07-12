import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';

typedef DashboardStat = ({String label, String value});

/// Gradient summary card used for the Application Progress section — a
/// title, an optional tap target (e.g. "My Applications"), and a row of
/// stat values.
class DashboardStatsCard extends StatelessWidget {
  const DashboardStatsCard({
    super.key,
    required this.title,
    required this.stats,
    this.onTap,
  });

  final String title;
  final List<DashboardStat> stats;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white70),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (var i = 0; i < stats.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xl),
                  _StatItem(stat: stats[i]),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final DashboardStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stat.value,
          style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
        ),
        Text(
          stat.label,
          style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
