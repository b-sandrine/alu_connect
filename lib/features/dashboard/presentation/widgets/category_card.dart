import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../opportunities/domain/entities/opportunity_entity.dart';
import '../../../opportunities/presentation/providers/opportunity_providers.dart';

const _categoryIcons = {
  OpportunityCategory.engineering: Icons.code_rounded,
  OpportunityCategory.design: Icons.palette_rounded,
  OpportunityCategory.marketing: Icons.campaign_rounded,
  OpportunityCategory.business: Icons.business_center_rounded,
  OpportunityCategory.research: Icons.science_rounded,
  OpportunityCategory.other: Icons.category_rounded,
};

/// "Browse by Category" row: an "All" chip plus one chip per
/// [OpportunityCategory], each showing a real Firestore-backed count.
/// Selecting a category highlights it and filters
/// [dashboardCategoryFilterProvider]; tapping the selected one again (or
/// "All") clears the filter.
class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dashboardCategoryFilterProvider);
    final countsAsync = ref.watch(categoryCountsProvider);

    return SizedBox(
      height: 92,
      child: countsAsync.when(
        data: (counts) => _list(ref, selected, counts),
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, __) => SizedBox(
            width: 88,
            child: AppSkeleton.box(context: context, height: 92, radius: AppRadius.lg),
          ),
        ),
        error: (_, __) => _list(ref, selected, const {}),
      ),
    );
  }

  Widget _list(WidgetRef ref, OpportunityCategory? selected, Map<OpportunityCategory, int> counts) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: OpportunityCategory.values.length + 1,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (index == 0) {
          return CategoryCard(
            label: 'All',
            icon: Icons.apps_rounded,
            count: counts.values.fold(0, (a, b) => a + b),
            selected: selected == null,
            onTap: () => ref.read(dashboardCategoryFilterProvider.notifier).state = null,
          );
        }
        final category = OpportunityCategory.values[index - 1];
        return CategoryCard(
          label: category.label,
          icon: _categoryIcons[category]!,
          count: counts[category] ?? 0,
          selected: selected == category,
          onTap: () => ref.read(dashboardCategoryFilterProvider.notifier).state =
              selected == category ? null : category,
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = selected ? Colors.white : colors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 88,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(colors: colors.heroGradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          color: selected ? null : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: selected ? Colors.transparent : colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 22),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: fg, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '$count',
              style: AppTextStyles.caption.copyWith(
                color: selected ? Colors.white.withValues(alpha: 0.85) : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
