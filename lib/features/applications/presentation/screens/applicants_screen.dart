import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/entities/application_entity.dart';
import '../providers/application_providers.dart';

class ApplicantsScreen extends ConsumerWidget {
  const ApplicantsScreen({super.key, required this.opportunityId});

  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync =
        ref.watch(opportunityApplicationsProvider(opportunityId));

    return Scaffold(
      appBar: AppBar(title: const Text('Applicants')),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(child: Text('No applications yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ApplicantCard(application: applications[i]),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _ApplicantCard extends ConsumerWidget {
  const _ApplicantCard({required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    application.applicantName.isNotEmpty
                        ? application.applicantName[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(application.applicantName,
                          style: AppTextStyles.titleSmall),
                      Text(
                        'Applied ${DateFormat.yMMMd().format(application.appliedAt)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: application.status),
              ],
            ),
            const SizedBox(height: 12),
            Text('Cover letter', style: AppTextStyles.labelSmall),
            const SizedBox(height: 6),
            Text(
              application.coverLetter,
              style: AppTextStyles.bodySmall,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            if (application.isPending) ...[
              const SizedBox(height: 16),
              _ReviewActions(application: application),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewActions extends ConsumerWidget {
  const _ReviewActions({required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(applicationControllerProvider).isLoading;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : () => _updateStatus(context, ref, ApplicationStatus.rejected),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: isLoading
                ? null
                : () => _updateStatus(context, ref, ApplicationStatus.accepted),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    ApplicationStatus status,
  ) async {
    await ref.read(applicationControllerProvider.notifier).updateStatus(
          applicationId: application.id,
          status: status,
        );

    if (!context.mounted) return;
    final error =
        ref.read(applicationControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ApplicationStatus.pending => ('Pending', AppColors.statusPending),
      ApplicationStatus.accepted => ('Accepted', AppColors.statusAccepted),
      ApplicationStatus.rejected => ('Rejected', AppColors.statusRejected),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: AppTextStyles.labelSmall.copyWith(color: color)),
    );
  }
}
