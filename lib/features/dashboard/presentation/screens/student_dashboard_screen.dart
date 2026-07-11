import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../../features/messaging/presentation/providers/messaging_providers.dart';
import '../../../../features/messaging/presentation/screens/conversations_screen.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/opportunities/presentation/screens/opportunities_screen.dart';
import '../../../../features/opportunities/presentation/widgets/opportunity_card.dart';
import '../../../../features/profiles/presentation/screens/student_profile_screen.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final unreadCount = ref.watch(unreadConversationCountProvider(user.id));

    final screens = [
      _HomeTab(userId: user.id, userName: user.displayName),
      const OpportunitiesScreen(),
      const BookmarksScreen(),
      const ConversationsScreen(),
      const StudentProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Discover',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.chat_bubble_outline),
            ),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab({required this.userId, required this.userName});

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync = ref.watch(filteredOpportunitiesProvider);
    final statsAsync = ref.watch(applicantApplicationStatsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${userName.split(' ').first}!',
                style: AppTextStyles.titleMedium),
            Text('Find your next opportunity',
                style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(opportunitiesStreamProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ApplicationsSummary(statsAsync: statsAsync),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent opportunities', style: AppTextStyles.titleSmall),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            opportunitiesAsync.when(
              data: (opportunities) {
                final recent = opportunities.take(5).toList();
                if (recent.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No opportunities yet'),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final o in recent) ...[
                      OpportunityCard(
                        opportunity: o,
                        onTap: () => context.push('/opportunities/${o.id}'),
                        trailing: BookmarkToggleButton(
                          userId: userId,
                          opportunityId: o.id,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorView(message: e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsSummary extends StatelessWidget {
  const _ApplicationsSummary({required this.statsAsync});

  final AsyncValue<ApplicationStats> statsAsync;

  @override
  Widget build(BuildContext context) {
    return statsAsync.when(
      data: (stats) {
        return InkWell(
          onTap: () => context.push('/my-applications'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Applications',
                  style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatItem(label: 'Total', value: '${stats.total}'),
                    const SizedBox(width: 24),
                    _StatItem(label: 'Pending', value: '${stats.pending}'),
                    const SizedBox(width: 24),
                    _StatItem(label: 'Accepted', value: '${stats.accepted}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 80, child: LoadingIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

