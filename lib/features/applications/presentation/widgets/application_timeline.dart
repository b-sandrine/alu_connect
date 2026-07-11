import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/application_entity.dart';

String applicationStatusLabel(ApplicationStatus status) {
  return switch (status) {
    ApplicationStatus.pending || ApplicationStatus.applied => 'Applied',
    ApplicationStatus.screening => 'Screening',
    ApplicationStatus.interview => 'Interview',
    ApplicationStatus.technicalAssessment => 'Technical Assessment',
    ApplicationStatus.offer => 'Offer',
    ApplicationStatus.accepted => 'Accepted',
    ApplicationStatus.rejected => 'Rejected',
  };
}

Color applicationStatusColor(ApplicationStatus status) {
  return switch (status) {
    ApplicationStatus.pending || ApplicationStatus.applied => AppColors.statusPending,
    ApplicationStatus.screening => AppColors.statusScreening,
    ApplicationStatus.interview => AppColors.statusInterview,
    ApplicationStatus.technicalAssessment => AppColors.statusTechnicalAssessment,
    ApplicationStatus.offer => AppColors.statusOffer,
    ApplicationStatus.accepted => AppColors.statusAccepted,
    ApplicationStatus.rejected => AppColors.statusRejected,
  };
}

/// A vertical stepper through the forward pipeline stages, or a distinct
/// "Rejected" terminal marker when the application was rejected instead of
/// completing the pipeline.
class ApplicationTimeline extends StatelessWidget {
  const ApplicationTimeline({super.key, required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context) {
    if (application.isRejected) {
      return _TimelineStep(
        label: 'Rejected',
        color: AppColors.statusRejected,
        icon: Icons.cancel_outlined,
        isDone: true,
        isLast: true,
        timestamp: application.reviewedAt,
        note: application.reviewNote,
      );
    }

    final currentIndex = application.currentStageIndex;
    const stages = ApplicationEntity.pipelineStages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stages.length; i++)
          _TimelineStep(
            label: applicationStatusLabel(stages[i]),
            color: applicationStatusColor(stages[i]),
            icon: _iconFor(stages[i]),
            isDone: i <= currentIndex,
            isLast: i == stages.length - 1,
            timestamp: _timestampFor(stages[i]),
            note: _noteFor(stages[i]),
          ),
      ],
    );
  }

  IconData _iconFor(ApplicationStatus status) {
    return switch (status) {
      ApplicationStatus.pending || ApplicationStatus.applied => Icons.send_outlined,
      ApplicationStatus.screening => Icons.fact_check_outlined,
      ApplicationStatus.interview => Icons.groups_outlined,
      ApplicationStatus.technicalAssessment => Icons.code_outlined,
      ApplicationStatus.offer => Icons.card_giftcard_outlined,
      ApplicationStatus.accepted => Icons.check_circle_outline,
      ApplicationStatus.rejected => Icons.cancel_outlined,
    };
  }

  DateTime? _timestampFor(ApplicationStatus status) {
    for (final event in application.statusHistory) {
      if (event.status == status) return event.changedAt;
    }
    return status == ApplicationStatus.applied ? application.appliedAt : null;
  }

  String? _noteFor(ApplicationStatus status) {
    for (final event in application.statusHistory) {
      if (event.status == status) return event.note;
    }
    return null;
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDone,
    required this.isLast,
    this.timestamp,
    this.note,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDone;
  final bool isLast;
  final DateTime? timestamp;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isDone ? color : AppColors.textHint;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? effectiveColor.withValues(alpha: 0.15) : null,
                  border: Border.all(color: effectiveColor, width: 1.5),
                ),
                child: Icon(icon, size: 16, color: effectiveColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? color.withValues(alpha: 0.4) : AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isDone ? AppColors.textPrimary : AppColors.textHint,
                    ),
                  ),
                  if (timestamp != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      DateFormat.yMMMd().add_jm().format(timestamp!),
                      style: AppTextStyles.caption,
                    ),
                  ],
                  if (note != null && note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(note!, style: AppTextStyles.bodySmall),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
