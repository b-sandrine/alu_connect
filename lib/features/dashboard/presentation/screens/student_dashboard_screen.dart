import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/bookmarks/presentation/providers/bookmark_providers.dart';
import '../../../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../../features/messaging/presentation/providers/messaging_providers.dart';
import '../../../../features/messaging/presentation/screens/conversations_screen.dart';
import '../../../../features/opportunities/domain/entities/opportunity_entity.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/opportunities/presentation/providers/recommended_opportunities_provider.dart';
import '../../../../features/opportunities/presentation/screens/opportunities_screen.dart';
import '../../../../features/opportunities/presentation/widgets/opportunity_card.dart';
import '../../../../features/profiles/presentation/providers/student_profile_providers.dart';
import '../../../../features/profiles/presentation/screens/student_profile_screen.dart';
import '../widgets/category_card.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/featured_opportunity_card.dart';
import '../widgets/opportunity_section.dart';
import '../widgets/profile_header.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  int _currentIndex = 0;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final unreadCount = ref.watch(unreadConversationCountProvider(user.id));

    final screens = [
      _HomeTab(userId: user.id, userName: user.displayName, onNavigateToTab: _goToTab),
      const OpportunitiesScreen(),
      const BookmarksScreen(),
      const ConversationsScreen(),
      const StudentProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _goToTab,
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
  const _HomeTab({
    required this.userId,
    required this.userName,
    required this.onNavigateToTab,
  });

  final String userId;
  final String userName;
  final void Function(int tabIndex) onNavigateToTab;

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(opportunitiesStreamProvider);
    ref.invalidate(opportunityCandidatePoolProvider);
    ref.invalidate(categoryCountsProvider);
    ref.invalidate(applicantApplicationsProvider(userId));
    ref.invalidate(studentProfileByOwnerProvider(userId));
    ref.invalidate(bookmarkedIdsProvider(userId));
    ref.invalidate(conversationsProvider(userId));
  }

  AsyncValue<List<OpportunityEntity>> _byCategory(
    AsyncValue<List<OpportunityEntity>> source,
    OpportunityCategory? category,
  ) {
    if (category == null) return source;
    return source.whenData((list) => list.where((o) => o.category == category).toList());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(applicantApplicationStatsProvider(userId));
    final categoryFilter = ref.watch(dashboardCategoryFilterProvider);

    final featuredAsync = _byCategory(ref.watch(featuredOpportunitiesProvider), categoryFilter);
    final recentlyPostedAsync =
        _byCategory(ref.watch(opportunityCandidatePoolProvider), categoryFilter);
    final savedAsync = ref.watch(savedOpportunitiesProvider(userId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ProfileHeader(
          userId: userId,
          userName: userName,
          onAvatarTap: () => onNavigateToTab(4),
          onNotificationsTap: () => onNavigateToTab(3),
        ),
        toolbarHeight: 72,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Browse by Category', style: AppTextStyles.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            const CategoryFilterBar(),
            const SizedBox(height: AppSpacing.xl),
            OpportunitySection<OpportunityEntity>(
              title: 'Featured Opportunities',
              itemsAsync: featuredAsync,
              horizontal: true,
              itemHeight: 210,
              emptyMessage: 'No featured opportunities right now',
              emptyIcon: Icons.local_fire_department_outlined,
              itemBuilder: (context, o) => FeaturedOpportunityCard(
                opportunity: o,
                onTap: () => context.push('/opportunities/${o.id}'),
                trailing: BookmarkToggleButton(userId: userId, opportunityId: o.id),
              ),
              onSeeAll: () => onNavigateToTab(1),
            ),
            const SizedBox(height: AppSpacing.xl),
            RecommendedOpportunitiesSection(studentId: userId),
            const SizedBox(height: AppSpacing.xl),
            OpportunitySection<OpportunityEntity>(
              title: 'Recently Posted',
              itemsAsync: recentlyPostedAsync.whenData((l) => l.take(5).toList()),
              emptyMessage: 'No opportunities yet',
              emptyIcon: Icons.work_outline,
              itemBuilder: (context, o) => OpportunityCard(
                opportunity: o,
                onTap: () => context.push('/opportunities/${o.id}'),
                trailing: BookmarkToggleButton(userId: userId, opportunityId: o.id),
              ),
              onSeeAll: () => onNavigateToTab(1),
            ),
            const SizedBox(height: AppSpacing.xl),
            RecentlyViewedSection(studentId: userId),
            const SizedBox(height: AppSpacing.xl),
            OpportunitySection<OpportunityEntity>(
              title: 'Saved Opportunities',
              itemsAsync: savedAsync.whenData((l) => l.take(5).toList()),
              emptyMessage: 'Tap the bookmark icon on any opportunity to save it here',
              emptyIcon: Icons.bookmark_border,
              itemBuilder: (context, o) => OpportunityCard(
                opportunity: o,
                onTap: () => context.push('/opportunities/${o.id}'),
                trailing: BookmarkToggleButton(userId: userId, opportunityId: o.id),
              ),
              onSeeAll: () => onNavigateToTab(2),
            ),
            const SizedBox(height: AppSpacing.xl),
            statsAsync.when(
              data: (stats) => DashboardStatsCard(
                title: 'My Applications',
                onTap: () => context.push('/my-applications'),
                stats: [
                  (label: 'Total', value: '${stats.total}'),
                  (label: 'Pending', value: '${stats.pending}'),
                  (label: 'Accepted', value: '${stats.accepted}'),
                ],
              ),
              loading: () => const SizedBox(height: 100),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.xl),
            UpcomingInterviewsSection(studentId: userId),
          ],
        ),
      ),
    );
  }
}
