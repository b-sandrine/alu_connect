import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../opportunities/domain/entities/opportunity_entity.dart';

/// Compact horizontally-scrolling card for the Featured Opportunities
/// section — distinct from the full-width [OpportunityCard] used in
/// vertical lists elsewhere.
class FeaturedOpportunityCard extends StatelessWidget {
  const FeaturedOpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
    this.trailing,
  });

  final OpportunityEntity opportunity;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.studentAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: opportunity.startupLogoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: Image.network(opportunity.startupLogoUrl!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.business_rounded, size: 18, color: colors.studentAccent),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department_rounded, size: 12, color: colors.accent),
                      const SizedBox(width: 3),
                      Text('${opportunity.viewCount}', style: AppTextStyles.caption.copyWith(color: colors.accent)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              opportunity.title,
              style: AppTextStyles.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              opportunity.startupName,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  opportunity.isRemote ? Icons.public_rounded : Icons.location_on_outlined,
                  size: 13,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    opportunity.isRemote ? 'Remote' : opportunity.location,
                    style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Deadline: ${DateFormat.MMMd().format(opportunity.deadline)}',
                    style: AppTextStyles.caption.copyWith(color: colors.textHint),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
