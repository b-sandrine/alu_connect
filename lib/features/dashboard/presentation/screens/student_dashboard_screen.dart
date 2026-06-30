import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/authentication/presentation/providers/auth_controller.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/opportunities/presentation/screens/opportunities_screen.dart';
import '../../../../features/opportunities/presentation/widgets/opportunity_card.dart';

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

    final screens = [
      _HomeTab(userId: user.id, userName: user.displayName),
      const OpportunitiesScreen(),
      const BookmarksScreen(),
      _ProfileTab(userId: user.id, userName: user.displayName),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
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
    final applicationsAsync = ref.watch(applicantApplicationsProvider(userId));

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
            _ApplicationsSummary(applicationsAsync: applicationsAsync),
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
  const _ApplicationsSummary({required this.applicationsAsync});

  final AsyncValue<dynamic> applicationsAsync;

  @override
  Widget build(BuildContext context) {
    return applicationsAsync.when(
      data: (applications) {
        final list = applications as List;
        final pending = list.where((a) {
          final dynamic app = a;
          return app.isPending as bool;
        }).length;
        final accepted = list.where((a) {
          final dynamic app = a;
          return app.isAccepted as bool;
        }).length;

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
                    _StatItem(label: 'Total', value: '${list.length}'),
                    const SizedBox(width: 24),
                    _StatItem(label: 'Pending', value: '$pending'),
                    const SizedBox(width: 24),
                    _StatItem(label: 'Accepted', value: '$accepted'),
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

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.userId, required this.userName});

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: AppTextStyles.displayMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(userName, style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.studentBadge.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Student',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.studentBadge),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _ProfileMenuItem(
            icon: Icons.inbox_outlined,
            label: 'My Applications',
            onTap: () => context.push('/my-applications'),
          ),
          _ProfileMenuItem(
            icon: Icons.bookmark_outline,
            label: 'Saved Opportunities',
            onTap: () => context.push('/bookmarks'),
          ),
          const Divider(height: 32),
          _ProfileMenuItem(
            icon: Icons.logout,
            label: 'Sign out',
            color: AppColors.error,
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textPrimary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: effectiveColor),
      title: Text(label,
          style: AppTextStyles.bodyMedium.copyWith(color: effectiveColor)),
      trailing: color == null
          ? const Icon(Icons.arrow_forward_ios,
              size: 16, color: AppColors.textHint)
          : null,
      onTap: onTap,
    );
  }
}
