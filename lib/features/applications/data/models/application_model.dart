import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/application_entity.dart';

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.id,
    required super.opportunityId,
    required super.opportunityTitle,
    required super.startupId,
    required super.startupName,
    required super.applicantId,
    required super.applicantName,
    required super.coverLetter,
    required super.status,
    required super.appliedAt,
    super.reviewedAt,
    super.reviewNote,
  });

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
}
