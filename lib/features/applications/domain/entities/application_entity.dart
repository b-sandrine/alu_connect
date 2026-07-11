import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_entity.freezed.dart';

/// The forward pipeline is applied -> screening -> interview ->
/// technicalAssessment -> offer -> accepted. `rejected` is reachable from
/// any non-terminal stage. `accepted`/`rejected` are terminal.
enum ApplicationStatus {
  pending,
  applied,
  screening,
  interview,
  technicalAssessment,
  offer,
  accepted,
  rejected,
}

@freezed
abstract class ApplicationStatusEvent with _$ApplicationStatusEvent {
  const factory ApplicationStatusEvent({
    required ApplicationStatus status,
    required DateTime changedAt,
    String? note,
  }) = _ApplicationStatusEvent;
}

@freezed
abstract class ApplicationEntity with _$ApplicationEntity {
  const ApplicationEntity._();

  const factory ApplicationEntity({
    required String id,
    required String opportunityId,
    required String opportunityTitle,
    required String startupId,
    required String startupName,
    required String applicantId,
    required String applicantName,
    required String coverLetter,
    required ApplicationStatus status,
    required DateTime appliedAt,
    DateTime? reviewedAt,
    String? reviewNote,
    @Default(<ApplicationStatusEvent>[]) List<ApplicationStatusEvent> statusHistory,
    DateTime? interviewScheduledAt,
    String? interviewLocation,
    String? interviewNotes,
    String? offerNote,
  }) = _ApplicationEntity;

  static const List<ApplicationStatus> pipelineStages = [
    ApplicationStatus.applied,
    ApplicationStatus.screening,
    ApplicationStatus.interview,
    ApplicationStatus.technicalAssessment,
    ApplicationStatus.offer,
    ApplicationStatus.accepted,
  ];

  // `pending` is a legacy alias for `applied`, kept in the enum only so
  // documents written before the pipeline existed still parse; treated as
  // equivalent to `applied` everywhere.
  bool get isPending =>
      status == ApplicationStatus.applied || status == ApplicationStatus.pending;
  bool get isAccepted => status == ApplicationStatus.accepted;
  bool get isRejected => status == ApplicationStatus.rejected;

  /// True while the application is still progressing through the pipeline
  /// (i.e. hasn't reached a terminal state).
  bool get isActive => !isAccepted && !isRejected;

  /// Index into [pipelineStages], or -1 if rejected (not part of the
  /// forward path).
  int get currentStageIndex {
    final effective =
        status == ApplicationStatus.pending ? ApplicationStatus.applied : status;
    return pipelineStages.indexOf(effective);
  }
}
