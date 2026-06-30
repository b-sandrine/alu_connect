import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/applications/domain/entities/application_entity.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/authentication/presentation/providers/auth_controller.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/opportunities/domain/entities/opportunity_entity.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/startup_profile/presentation/providers/startup_profile_providers.dart';

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

    final screens = [
      _HomeTab(userId: user.id),
      _OpportunitiesTab(userId: user.id),
      _ApplicationsTab(startupId: user.id),
      _ProfileTab(userId: user.id, userName: user.displayName),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Postings',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Applicants',
          ),
          NavigationDestination(
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
    final opportunitiesAsync =
        ref.watch(opportunitiesByStartupProvider(userId));
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatsRow(
            opportunitiesAsync: opportunitiesAsync,
            applicationsAsync: applicationsAsync,
          ),
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
  const _StatsRow({
    required this.opportunitiesAsync,
    required this.applicationsAsync,
  });

  final AsyncValue<List<OpportunityEntity>> opportunitiesAsync;
  final AsyncValue<List<ApplicationEntity>> applicationsAsync;

  @override
  Widget build(BuildContext context) {
    final totalPostings = opportunitiesAsync.valueOrNull?.length ?? 0;
    final totalApplicants = applicationsAsync.valueOrNull?.length ?? 0;
    final pendingReview = applicationsAsync.valueOrNull
            ?.where((a) => a.isPending)
            .length ??
        0;

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
    final (_, statusColor) = switch (application.status) {
      ApplicationStatus.pending => ('Pending', AppColors.statusPending),
      ApplicationStatus.accepted => ('Accepted', AppColors.statusAccepted),
      ApplicationStatus.rejected => ('Rejected', AppColors.statusRejected),
    };

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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  title: Text(o.title, style: AppTextStyles.titleSmall),
                  subtitle: Text(
                    '${o.type.name} · ${o.requiredSkills.take(2).join(', ')}',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: PopupMenuButton(
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

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.userId, required this.userName});

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(startupProfileByOwnerProvider(userId));
    final profile = profileAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/startup-profile/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.business,
                      size: 36, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text(profile?.companyName ?? userName,
                    style: AppTextStyles.titleLarge),
                if (profile != null) ...[
                  const SizedBox(height: 4),
                  Text(profile.tagline, style: AppTextStyles.bodySmall),
                  if (profile.isVerified) ...[
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified,
                            size: 16, color: AppColors.verifiedBadge),
                        SizedBox(width: 4),
                        Text('Verified',
                            style: TextStyle(color: AppColors.verifiedBadge)),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          _ProfileMenuItem(
            icon: Icons.person_outlined,
            label: 'View public profile',
            onTap: () => context.push('/startup-profile/$userId'),
          ),
          _ProfileMenuItem(
            icon: Icons.edit_outlined,
            label: 'Edit profile',
            onTap: () => context.push('/startup-profile/edit'),
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
