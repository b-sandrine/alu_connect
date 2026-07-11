import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_entity.freezed.dart';

enum ApplicationStatus { pending, accepted, rejected }

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
  }) = _ApplicationEntity;

  bool get isPending => status == ApplicationStatus.pending;
  bool get isAccepted => status == ApplicationStatus.accepted;
  bool get isRejected => status == ApplicationStatus.rejected;
}
