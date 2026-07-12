import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/messaging/presentation/providers/messaging_providers.dart';
import '../../domain/entities/application_entity.dart';
import '../providers/application_providers.dart';
import '../widgets/application_timeline.dart';

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
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  tooltip: 'Message ${application.applicantName}',
                  onPressed: () => _messageApplicant(context, ref),
                ),
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
            if (application.isActive) ...[
              const SizedBox(height: 16),
              _StageActions(application: application),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _messageApplicant(BuildContext context, WidgetRef ref) async {
    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) return;

    final conversation =
        await ref.read(messagingControllerProvider.notifier).startConversation(
              currentUserId: currentUser.id,
              currentUserName: currentUser.displayName,
              currentUserPhotoUrl: currentUser.photoUrl,
              otherUserId: application.applicantId,
              otherUserName: application.applicantName,
              contextOpportunityId: application.opportunityId,
              contextOpportunityTitle: application.opportunityTitle,
            );

    if (conversation != null && context.mounted) {
      context.push('/messages/${conversation.id}');
    }
  }
}

class _StageActions extends ConsumerWidget {
  const _StageActions({required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(applicationControllerProvider).isLoading;
    final controller = ref.read(applicationControllerProvider.notifier);

    Widget? primaryButton;
    switch (application.status) {
      case ApplicationStatus.pending:
      case ApplicationStatus.applied:
        primaryButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => _run(context, ref, () => controller.shortlist(application)),
          child: const Text('Shortlist'),
        );
      case ApplicationStatus.screening:
        primaryButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => _showScheduleInterviewDialog(context, ref, application),
          child: const Text('Schedule interview'),
        );
      case ApplicationStatus.interview:
        primaryButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => _run(
                  context, ref, () => controller.moveToTechnicalAssessment(application)),
          child: const Text('Technical assessment'),
        );
      case ApplicationStatus.technicalAssessment:
        primaryButton = FilledButton(
          onPressed: isLoading
              ? null
              : () => _showMakeOfferDialog(context, ref, application),
          child: const Text('Make offer'),
        );
      case ApplicationStatus.offer:
        primaryButton = const OutlinedButton(
          onPressed: null,
          child: Text('Awaiting response'),
        );
      case ApplicationStatus.accepted:
      case ApplicationStatus.rejected:
        primaryButton = null;
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : () => _showRejectDialog(context, ref, application),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            child: const Text('Reject'),
          ),
        ),
        if (primaryButton != null) ...[
          const SizedBox(width: 12),
          Expanded(child: primaryButton),
        ],
      ],
    );
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    await action();
    if (!context.mounted) return;
    final error =
        ref.read(applicationControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _showRejectDialog(
    BuildContext context,
    WidgetRef ref,
    ApplicationEntity application,
  ) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject applicant'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Note to applicant (optional)',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(applicationControllerProvider.notifier).reject(
            application,
            note: noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
          ),
    );
  }

  Future<void> _showMakeOfferDialog(
    BuildContext context,
    WidgetRef ref,
    ApplicationEntity application,
  ) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Make offer'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Offer details (optional)',
            hintText: 'Stipend, start date, next steps...',
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Send offer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(applicationControllerProvider.notifier).makeOffer(
            application,
            note: noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
          ),
    );
  }

  Future<void> _showScheduleInterviewDialog(
    BuildContext context,
    WidgetRef ref,
    ApplicationEntity application,
  ) async {
    final result = await showDialog<_InterviewDetails>(
      context: context,
      builder: (_) => const _ScheduleInterviewDialog(),
    );
    if (result == null || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref.read(applicationControllerProvider.notifier).scheduleInterview(
            application,
            scheduledAt: result.scheduledAt,
            location: result.location,
            meetingLink: result.meetingLink,
            notes: result.notes,
          ),
    );
  }
}

class _InterviewDetails {
  const _InterviewDetails({
    required this.scheduledAt,
    required this.location,
    this.meetingLink,
    this.notes,
  });

  final DateTime scheduledAt;
  final String location;
  final String? meetingLink;
  final String? notes;
}

class _ScheduleInterviewDialog extends StatefulWidget {
  const _ScheduleInterviewDialog();

  @override
  State<_ScheduleInterviewDialog> createState() =>
      _ScheduleInterviewDialogState();
}

class _ScheduleInterviewDialogState extends State<_ScheduleInterviewDialog> {
  DateTime? _date;
  TimeOfDay? _time;
  final _locationController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _meetingLinkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _confirm() {
    if (_date == null || _time == null || _locationController.text.trim().isEmpty) {
      return;
    }
    final scheduledAt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );
    Navigator.pop(
      context,
      _InterviewDetails(
        scheduledAt: scheduledAt,
        location: _locationController.text.trim(),
        meetingLink: _meetingLinkController.text.trim().isEmpty
            ? null
            : _meetingLinkController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _date != null &&
        _time != null &&
        _locationController.text.trim().isNotEmpty;

    return AlertDialog(
      title: const Text('Schedule interview'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(_date == null
                  ? 'Select date'
                  : DateFormat.yMMMd().format(_date!)),
              onTap: _pickDate,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time_outlined),
              title: Text(_time == null ? 'Select time' : _time!.format(context)),
              onTap: _pickTime,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g. Office address, or "Virtual"',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _meetingLinkController,
              decoration: const InputDecoration(
                labelText: 'Meeting link (optional)',
                hintText: 'Zoom, Google Meet, etc.',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: canConfirm ? _confirm : null,
          child: const Text('Schedule'),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final color = applicationStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(applicationStatusLabel(status),
          style: AppTextStyles.labelSmall.copyWith(color: color)),
    );
  }
}
