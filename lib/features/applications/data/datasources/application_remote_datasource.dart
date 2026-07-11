import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../../domain/entities/application_entity.dart';
import '../models/application_model.dart';

class ApplicationRemoteDatasource {
  const ApplicationRemoteDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.applicationsCollection);

  // Uses a Firestore transaction to prevent race conditions
  // when multiple users apply to the same opportunity simultaneously.
  Future<ApplicationModel> submitApplication(ApplicationModel application) async {
    try {
      final docRef = _collection.doc();

      await _firestore.runTransaction((transaction) async {
        final existingQuery = await _collection
            .where('applicantId', isEqualTo: application.applicantId)
            .where('opportunityId', isEqualTo: application.opportunityId)
            .limit(1)
            .get();

        if (existingQuery.docs.isNotEmpty) {
          throw const ValidationException(
            'You have already applied to this opportunity.',
          );
        }

        final now = DateTime.now();
        final withId = ApplicationModel(
          id: docRef.id,
          opportunityId: application.opportunityId,
          opportunityTitle: application.opportunityTitle,
          startupId: application.startupId,
          startupName: application.startupName,
          applicantId: application.applicantId,
          applicantName: application.applicantName,
          coverLetter: application.coverLetter,
          status: ApplicationStatus.applied,
          appliedAt: now,
          statusHistory: [
            ApplicationStatusEvent(status: ApplicationStatus.applied, changedAt: now),
          ],
        );

        transaction.set(docRef, withId.toFirestore());
      });

      final created = await docRef.get();
      return ApplicationModel.fromFirestore(created);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<bool> hasApplied({
    required String applicantId,
    required String opportunityId,
  }) async {
    try {
      final query = await _collection
          .where('applicantId', isEqualTo: applicantId)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Stream<List<ApplicationModel>> watchApplicationsByApplicant(String applicantId) {
    return _collection
        .where('applicantId', isEqualTo: applicantId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ApplicationModel.fromFirestore).toList());
  }

  Stream<List<ApplicationModel>> watchApplicationsByOpportunity(
      String opportunityId) {
    return _collection
        .where('opportunityId', isEqualTo: opportunityId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ApplicationModel.fromFirestore).toList());
  }

  Stream<List<ApplicationModel>> watchApplicationsByStartup(String startupId) {
    return _collection
        .where('startupId', isEqualTo: startupId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ApplicationModel.fromFirestore).toList());
  }

  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? reviewNote,
    DateTime? interviewScheduledAt,
    String? interviewLocation,
    String? interviewNotes,
    String? offerNote,
  }) async {
    try {
      final now = DateTime.now();
      final update = <String, dynamic>{
        'status': status.name,
        'reviewedAt': Timestamp.fromDate(now),
        'reviewNote': reviewNote,
        'statusHistory': FieldValue.arrayUnion([
          {
            'status': status.name,
            'changedAt': Timestamp.fromDate(now),
            'note': reviewNote,
          },
        ]),
      };
      if (interviewScheduledAt != null) {
        update['interviewScheduledAt'] = Timestamp.fromDate(interviewScheduledAt);
      }
      if (interviewLocation != null) update['interviewLocation'] = interviewLocation;
      if (interviewNotes != null) update['interviewNotes'] = interviewNotes;
      if (offerNote != null) update['offerNote'] = offerNote;

      await _collection.doc(applicationId).update(update);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }
}
