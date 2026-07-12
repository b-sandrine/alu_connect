import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/application_entity.dart';

ApplicationStatusEvent _eventFromMap(Map<String, dynamic> map) {
  return ApplicationStatusEvent(
    status: ApplicationStatus.values.byName(map['status'] as String),
    changedAt: (map['changedAt'] as Timestamp).toDate(),
    note: map['note'] as String?,
  );
}

Map<String, dynamic> _eventToMap(ApplicationStatusEvent e) {
  return {
    'status': e.status.name,
    'changedAt': Timestamp.fromDate(e.changedAt),
    'note': e.note,
  };
}

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
    this.statusHistory = const [],
    this.interviewScheduledAt,
    this.interviewLocation,
    this.meetingLink,
    this.interviewNotes,
    this.offerNote,
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
  final List<ApplicationStatusEvent> statusHistory;
  final DateTime? interviewScheduledAt;
  final String? interviewLocation;
  final String? meetingLink;
  final String? interviewNotes;
  final String? offerNote;

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
      statusHistory: (data['statusHistory'] as List? ?? [])
          .map((e) => _eventFromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      interviewScheduledAt: data['interviewScheduledAt'] != null
          ? (data['interviewScheduledAt'] as Timestamp).toDate()
          : null,
      interviewLocation: data['interviewLocation'] as String?,
      meetingLink: data['meetingLink'] as String?,
      interviewNotes: data['interviewNotes'] as String?,
      offerNote: data['offerNote'] as String?,
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
      statusHistory: e.statusHistory,
      interviewScheduledAt: e.interviewScheduledAt,
      interviewLocation: e.interviewLocation,
      meetingLink: e.meetingLink,
      interviewNotes: e.interviewNotes,
      offerNote: e.offerNote,
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
      'statusHistory': statusHistory.map(_eventToMap).toList(),
      'interviewScheduledAt': interviewScheduledAt != null
          ? Timestamp.fromDate(interviewScheduledAt!)
          : null,
      'interviewLocation': interviewLocation,
      'meetingLink': meetingLink,
      'interviewNotes': interviewNotes,
      'offerNote': offerNote,
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
      statusHistory: statusHistory,
      interviewScheduledAt: interviewScheduledAt,
      interviewLocation: interviewLocation,
      meetingLink: meetingLink,
      interviewNotes: interviewNotes,
      offerNote: offerNote,
    );
  }
}
