import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/error_view.dart';

/// Generic "Title + See all + list" section used for every dashboard list
/// (Featured, Recommended, Recently Posted, Recently Viewed, Saved). Handles
/// loading/empty/error presentation once instead of duplicating it per
/// section.
class OpportunitySection<T> extends StatelessWidget {
  const OpportunitySection({
    super.key,
    required this.title,
    required this.itemsAsync,
    required this.itemBuilder,
    this.onSeeAll,
    this.horizontal = false,
    this.itemHeight = 200,
    this.emptyMessage = 'Nothing here yet',
    this.emptyIcon = Icons.inbox_outlined,
  });

  final String title;
  final AsyncValue<List<T>> itemsAsync;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback? onSeeAll;
  final bool horizontal;
  final double itemHeight;
  final String emptyMessage;
  final IconData emptyIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.titleSmall),
            if (onSeeAll != null)
              TextButton(onPressed: onSeeAll, child: const Text('See all')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    Icon(emptyIcon, size: 32, color: colors.textHint),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      emptyMessage,
                      style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (horizontal) {
              return SizedBox(
                height: itemHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, i) => itemBuilder(context, items[i]),
                ),
              );
            }

            return Column(
              children: [
                for (final item in items) ...[
                  itemBuilder(context, item),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
          loading: () => horizontal
              ? SizedBox(
                  height: itemHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                    itemBuilder: (_, __) => SizedBox(
                      width: 220,
                      child: AppSkeleton.box(context: context, height: itemHeight, radius: AppRadius.lg),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < 2; i++) ...[
                      AppSkeleton.box(context: context, height: 100, radius: AppRadius.lg),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
          error: (e, _) => ErrorView(message: e.toString()),
        ),
      ],
    );
  }
}
