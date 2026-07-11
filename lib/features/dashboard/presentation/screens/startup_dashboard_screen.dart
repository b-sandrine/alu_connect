import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/applications/domain/entities/application_entity.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/bookmarks/presentation/providers/bookmark_providers.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/applications/presentation/widgets/application_timeline.dart';
import '../../../../features/messaging/presentation/providers/messaging_providers.dart';
import '../../../../features/messaging/presentation/screens/conversations_screen.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/profiles/presentation/providers/startup_profile_providers.dart';
import '../../../../features/profiles/presentation/screens/startup_profile_screen.dart';
import '../providers/dashboard_stats_provider.dart';

class StartupDashboardScreen extends ConsumerStatefulWidget {
  const StartupDashboardScreen({super.key});

  @override
  ConsumerState<StartupDashboardScreen> createState() =>
      _StartupDashboardScreenState();
}

class _StartupDashboardScreenState
    extends ConsumerState<StartupDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final unreadCount = ref.watch(unreadConversationCountProvider(user.id));

    final screens = [
      _HomeTab(userId: user.id),
      _OpportunitiesTab(userId: user.id),
      _ApplicationsTab(startupId: user.id),
      const ConversationsScreen(),
      StartupProfileScreen(ownerId: user.id),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          const NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Postings',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Applicants',
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
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync =
        ref.watch(startupApplicationsProvider(userId));
    final profileAsync =
        ref.watch(startupProfileByOwnerProvider(userId));

    final companyName = profileAsync.value?.companyName ?? 'Your startup';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(companyName, style: AppTextStyles.titleMedium),
            Text('Startup dashboard', style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Analytics',
            onPressed: () => context.push('/startup-analytics'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatsRow(statsAsync: ref.watch(startupDashboardStatsProvider(userId))),
          const SizedBox(height: 24),
          _RecentApplicationsSection(
            applicationsAsync: applicationsAsync,
            startupId: userId,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.statsAsync});

  final AsyncValue<StartupDashboardStats> statsAsync;

  @override
  Widget build(BuildContext context) {
    final stats = statsAsync.valueOrNull;
    final totalPostings = stats?.totalPostings ?? 0;
    final totalApplicants = stats?.totalApplicants ?? 0;
    final pendingReview = stats?.pendingReview ?? 0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Active Postings',
            value: '$totalPostings',
            icon: Icons.work_outline,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Applicants',
            value: '$totalApplicants',
            icon: Icons.people_outline,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Pending',
            value: '$pendingReview',
            icon: Icons.hourglass_empty,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

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
          Text(value,
              style:
                  AppTextStyles.displayMedium.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _RecentApplicationsSection extends ConsumerWidget {
  const _RecentApplicationsSection({
    required this.applicationsAsync,
    required this.startupId,
  });

  final AsyncValue<List<ApplicationEntity>> applicationsAsync;
  final String startupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent applicants', style: AppTextStyles.titleSmall),
            TextButton(
              onPressed: () {},
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        applicationsAsync.when(
          data: (applications) {
            if (applications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No applications yet',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              );
            }
            final recent = applications.take(5).toList();
            return Column(
              children: recent
                  .map((a) => _RecentApplicationTile(application: a))
                  .toList(),
            );
          },
          loading: () => const LoadingIndicator(),
          error: (e, _) => ErrorView(message: e.toString()),
        ),
      ],
    );
  }
}

class _RecentApplicationTile extends StatelessWidget {
  const _RecentApplicationTile({required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context) {
    final statusColor = applicationStatusColor(application.status);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          application.applicantName.isNotEmpty
              ? application.applicantName[0].toUpperCase()
              : '?',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
        ),
      ),
      title: Text(application.applicantName, style: AppTextStyles.titleSmall),
      subtitle: Text(application.opportunityTitle,
          style: AppTextStyles.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
        ),
      ),
      onTap: () => context.push(
        '/opportunities/${application.opportunityId}/applicants',
      ),
    );
  }
}

class _OpportunitiesTab extends ConsumerWidget {
  const _OpportunitiesTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync =
        ref.watch(opportunitiesByStartupProvider(userId));
    final applicationsAsync = ref.watch(startupApplicationsProvider(userId));
    final applicationCountByOpportunity = <String, int>{};
    for (final a in applicationsAsync.valueOrNull ?? const []) {
      applicationCountByOpportunity[a.opportunityId] =
          (applicationCountByOpportunity[a.opportunityId] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Postings')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/opportunities/new'),
        icon: const Icon(Icons.add),
        label: const Text('Post opportunity'),
      ),
      body: opportunitiesAsync.when(
        data: (opportunities) {
          if (opportunities.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.work_off_outlined,
                      size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text("No postings yet",
                      style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => context.push('/opportunities/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Post first opportunity'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: opportunities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final o = opportunities[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(o.title, style: AppTextStyles.titleSmall),
                                const SizedBox(height: 2),
                                Text(
                                  '${o.type.name} · ${o.requiredSkills.take(2).join(', ')}',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                  value: 'applicants',
                                  child: Text('View applicants')),
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            ],
                            onSelected: (v) {
                              if (v == 'applicants') {
                                context.push('/opportunities/${o.id}/applicants');
                              } else if (v == 'edit') {
                                context.push('/opportunities/${o.id}/edit', extra: o);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _PostingStatsRow(
                        views: o.viewCount,
                        applications: applicationCountByOpportunity[o.id] ?? 0,
                        opportunityId: o.id,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _PostingStatsRow extends ConsumerWidget {
  const _PostingStatsRow({
    required this.views,
    required this.applications,
    required this.opportunityId,
  });

  final int views;
  final int applications;
  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkCountAsync = ref.watch(bookmarkCountProvider(opportunityId));

    return Row(
      children: [
        _StatChip(icon: Icons.visibility_outlined, value: views),
        const SizedBox(width: 12),
        _StatChip(icon: Icons.people_outline, value: applications),
        const SizedBox(width: 12),
        _StatChip(icon: Icons.bookmark_border, value: bookmarkCountAsync.valueOrNull ?? 0),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value});

  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('$value', style: AppTextStyles.caption),
      ],
    );
  }
}

class _ApplicationsTab extends ConsumerWidget {
  const _ApplicationsTab({required this.startupId});

  final String startupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync =
        ref.watch(startupApplicationsProvider(startupId));

    return Scaffold(
      appBar: AppBar(title: const Text('All Applicants')),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(child: Text('No applicants yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) =>
                _RecentApplicationTile(application: applications[i]),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

