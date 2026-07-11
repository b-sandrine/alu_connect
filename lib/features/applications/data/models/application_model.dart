import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/application_entity.dart';

class ApplicationModel {
  const ApplicationModel({
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

  factory ApplicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ApplicationModel(
      id: doc.id,
      opportunityId: data['opportunityId'] as String,
      opportunityTitle: data['opportunityTitle'] as String,
      startupId: data['startupId'] as String,
      startupName: data['startupName'] as String,
      applicantId: data['applicantId'] as String,
      applicantName: data['applicantName'] as String,
      coverLetter: data['coverLetter'] as String,
      status: ApplicationStatus.values.byName(data['status'] as String),
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
      reviewedAt: data['reviewedAt'] != null
          ? (data['reviewedAt'] as Timestamp).toDate()
          : null,
      reviewNote: data['reviewNote'] as String?,
    );
  }

  factory ApplicationModel.fromEntity(ApplicationEntity e) {
    return ApplicationModel(
      id: e.id,
      opportunityId: e.opportunityId,
      opportunityTitle: e.opportunityTitle,
      startupId: e.startupId,
      startupName: e.startupName,
      applicantId: e.applicantId,
      applicantName: e.applicantName,
      coverLetter: e.coverLetter,
      status: e.status,
      appliedAt: e.appliedAt,
      reviewedAt: e.reviewedAt,
      reviewNote: e.reviewNote,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'startupId': startupId,
      'startupName': startupName,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'coverLetter': coverLetter,
      'status': status.name,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'reviewNote': reviewNote,
    };
  }

  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      opportunityId: opportunityId,
      opportunityTitle: opportunityTitle,
      startupId: startupId,
      startupName: startupName,
      applicantId: applicantId,
      applicantName: applicantName,
      coverLetter: coverLetter,
      status: status,
      appliedAt: appliedAt,
      reviewedAt: reviewedAt,
      reviewNote: reviewNote,
    );
  }
}
