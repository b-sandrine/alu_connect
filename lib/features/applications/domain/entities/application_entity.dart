import 'package:equatable/equatable.dart';

enum ApplicationStatus { pending, accepted, rejected }

class ApplicationEntity extends Equatable {
  const ApplicationEntity({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.startupId,
    required this.startupName,
    required this.applicantId,
    required this.applicantName,
    required this.coverLetter,
    required this.status,
    required this.appliedAt,
    this.reviewedAt,
    this.reviewNote,
  });

  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final String startupId;
  final String startupName;
  final String applicantId;
  final String applicantName;
  final String coverLetter;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? reviewedAt;
  final String? reviewNote;

  bool get isPending => status == ApplicationStatus.pending;
  bool get isAccepted => status == ApplicationStatus.accepted;
  bool get isRejected => status == ApplicationStatus.rejected;

  @override
  List<Object?> get props => [
        id, opportunityId, opportunityTitle, startupId, startupName,
        applicantId, applicantName, coverLetter, status, appliedAt,
        reviewedAt, reviewNote,
      ];
}
