import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/authentication/domain/entities/user_entity.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/messaging/presentation/providers/messaging_providers.dart';
import '../../domain/entities/opportunity_entity.dart';
import '../providers/opportunity_providers.dart';

final _opportunityDetailProvider =
    FutureProvider.family<OpportunityEntity, String>((ref, id) {
  return ref.watch(opportunityRepositoryProvider).getOpportunityById(id);
});

class OpportunityDetailScreen extends ConsumerStatefulWidget {
  const OpportunityDetailScreen({super.key, required this.opportunityId});

  final String opportunityId;

  @override
  ConsumerState<OpportunityDetailScreen> createState() =>
      _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState
    extends ConsumerState<OpportunityDetailScreen> {
  bool _viewRecorded = false;

  void _maybeRecordView(UserEntity? user) {
    if (_viewRecorded || user == null || !user.isStudent) return;
    _viewRecorded = true;
    recordOpportunityView(ref, widget.opportunityId);
    recordRecentlyViewed(ref, user.id, widget.opportunityId);
  }

  @override
  Widget build(BuildContext context) {
    final opportunityAsync =
        ref.watch(_opportunityDetailProvider(widget.opportunityId));
    final user = ref.watch(authStateProvider).value;
    _maybeRecordView(user);

    return Scaffold(
      body: opportunityAsync.when(
        data: (opportunity) =>
            _DetailContent(opportunity: opportunity, user: user),
        loading: () => const LoadingIndicator(),
        error: (e, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(message: e.toString()),
        ),
      ),
      bottomNavigationBar: opportunityAsync.maybeWhen(
        data: (opportunity) {
          final canApply = user != null &&
              user.isStudent &&
              opportunity.isActive &&
              !opportunity.isExpired;
          if (!canApply) return null;
          return ApplyButton(
            opportunityId: opportunity.id,
            applicantId: user.id,
          );
        },
        orElse: () => null,
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.opportunity, required this.user});

  final OpportunityEntity opportunity;
  final UserEntity? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStartupOwner =
        user?.isStartup == true && user?.id == opportunity.startupId;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            opportunity.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            if (user != null && user!.isStudent)
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                tooltip: 'Message ${opportunity.startupName}',
                onPressed: () => _messageStartup(context, ref),
              ),
            if (isStartupOwner)
              PopupMenuButton(
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    context.push('/opportunities/${opportunity.id}/edit',
                        extra: opportunity);
                  } else if (value == 'delete') {
                    await _confirmDelete(context, ref);
                  }
                },
              ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _HeaderSection(opportunity: opportunity),
              const SizedBox(height: 20),
              _DetailsSection(opportunity: opportunity),
              const SizedBox(height: 20),
              _SkillsSection(skills: opportunity.requiredSkills),
              const SizedBox(height: 20),
              _DescriptionSection(description: opportunity.description),
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _messageStartup(BuildContext context, WidgetRef ref) async {
    final currentUser = user;
    if (currentUser == null) return;

    final conversation =
        await ref.read(messagingControllerProvider.notifier).startConversation(
              currentUserId: currentUser.id,
              currentUserName: currentUser.displayName,
              currentUserPhotoUrl: currentUser.photoUrl,
              otherUserId: opportunity.startupId,
              otherUserName: opportunity.startupName,
              otherUserPhotoUrl: opportunity.startupLogoUrl,
              contextOpportunityId: opportunity.id,
              contextOpportunityTitle: opportunity.title,
            );

    if (conversation != null && context.mounted) {
      context.push('/messages/${conversation.id}');
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete opportunity?'),
        content: const Text(
          'This will remove the opportunity from the listing. Applications already submitted will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(opportunityControllerProvider.notifier)
          .deleteOpportunity(opportunity.id);
      if (context.mounted) context.pop();
    }
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.opportunity});
  final OpportunityEntity opportunity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(opportunity.startupName, style: AppTextStyles.bodySmall),
        const SizedBox(height: 4),
        Text(opportunity.title, style: AppTextStyles.displayMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Badge(
              label: _typeLabel(opportunity.type),
              color: AppColors.primary,
            ),
            _Badge(
              label: opportunity.category.name,
              color: AppColors.secondary,
            ),
            if (opportunity.isRemote)
              const _Badge(label: 'Remote', color: AppColors.success),
          ],
        ),
      ],
    );
  }

  String _typeLabel(OpportunityType type) {
    const labels = {
      OpportunityType.internship: 'Internship',
      OpportunityType.partTime: 'Part-time',
      OpportunityType.fullTime: 'Full-time',
      OpportunityType.contract: 'Contract',
      OpportunityType.volunteer: 'Volunteer',
    };
    return labels[type] ?? type.name;
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.opportunity});
  final OpportunityEntity opportunity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: opportunity.location,
            ),
            const Divider(height: 20),
            _InfoRow(
              icon: Icons.schedule,
              label:
                  'Deadline: ${DateFormat.yMMMd().format(opportunity.deadline)}',
              valueColor:
                  opportunity.isExpired ? AppColors.error : AppColors.textPrimary,
            ),
            if (opportunity.compensation != null) ...[
              const Divider(height: 20),
              _InfoRow(
                icon: Icons.payments_outlined,
                label: opportunity.compensation!,
                valueColor: AppColors.success,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.valueColor});
  final IconData icon;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({required this.skills});
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Required skills', style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    s,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About this opportunity', style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        Text(description, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class ApplyButton extends ConsumerWidget {
  const ApplyButton({
    super.key,
    required this.opportunityId,
    required this.applicantId,
  });

  final String opportunityId;
  final String applicantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAppliedAsync = ref.watch(hasAppliedProvider((
      applicantId: applicantId,
      opportunityId: opportunityId,
    )));
    final hasApplied = hasAppliedAsync.valueOrNull ?? false;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          label: hasApplied ? 'Already applied' : 'Apply now',
          onPressed: hasApplied
              ? null
              : () => context.push('/opportunities/$opportunityId/apply'),
        ),
      ),
    );
  }
}
