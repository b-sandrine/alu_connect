import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/opportunities/presentation/widgets/opportunity_card.dart';
import '../providers/bookmark_providers.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final bookmarkedIdsAsync = ref.watch(bookmarkedIdsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarkedIdsAsync.when(
        data: (bookmarkedIds) {
          if (bookmarkedIds.isEmpty) {
            return const _EmptyState();
          }

          final bookmarkedOpportunitiesAsync =
              ref.watch(opportunitiesByIdsProvider(bookmarkedIds));

          return bookmarkedOpportunitiesAsync.when(
            data: (bookmarked) {
              if (bookmarked.isEmpty) {
                return const _EmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarked.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => OpportunityCard(
                  opportunity: bookmarked[i],
                  onTap: () =>
                      context.push('/opportunities/${bookmarked[i].id}'),
                  trailing: _BookmarkButton(
                    userId: user.id,
                    opportunityId: bookmarked[i].id,
                  ),
                ),
              );
            },
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorView(message: e.toString()),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _BookmarkButton extends ConsumerWidget {
  const _BookmarkButton({
    required this.userId,
    required this.opportunityId,
  });

  final String userId;
  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.bookmark, color: AppColors.primary),
      onPressed: () => ref.read(bookmarkControllerProvider.notifier).toggle(
            userId: userId,
            opportunityId: opportunityId,
          ),
    );
  }
}

// Reusable bookmark toggle button for use on opportunity cards elsewhere
class BookmarkToggleButton extends ConsumerWidget {
  const BookmarkToggleButton({
    super.key,
    required this.userId,
    required this.opportunityId,
  });

  final String userId;
  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIdsAsync = ref.watch(bookmarkedIdsProvider(userId));
    final isBookmarked = bookmarkedIdsAsync.whenData(
      (ids) => ids.contains(opportunityId),
    );

    return IconButton(
      icon: Icon(
        isBookmarked.valueOrNull == true
            ? Icons.bookmark
            : Icons.bookmark_border,
        color: AppColors.primary,
      ),
      onPressed: () => ref.read(bookmarkControllerProvider.notifier).toggle(
            userId: userId,
            opportunityId: opportunityId,
          ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bookmark_border, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No bookmarks yet', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on any opportunity to save it here',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
