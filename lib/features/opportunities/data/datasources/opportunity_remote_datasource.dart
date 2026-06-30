import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../models/opportunity_model.dart';

class OpportunityRemoteDatasource {
  const OpportunityRemoteDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.opportunitiesCollection);

  Stream<List<OpportunityModel>> watchOpportunities() {
    return _collection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map(OpportunityModel.fromFirestore).toList());
  }

  Stream<List<OpportunityModel>> watchOpportunitiesByStartup(String startupId) {
    return _collection
        .where('startupId', isEqualTo: startupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map(OpportunityModel.fromFirestore).toList());
  }

  Future<OpportunityModel> getOpportunityById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) throw const NotFoundException('Opportunity not found.');
      return OpportunityModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<OpportunityModel> createOpportunity(OpportunityModel opportunity) async {
    try {
      final docRef = _collection.doc();
      final withId = OpportunityModel(
        id: docRef.id,
        startupId: opportunity.startupId,
        startupName: opportunity.startupName,
        startupLogoUrl: opportunity.startupLogoUrl,
        title: opportunity.title,
        description: opportunity.description,
        type: opportunity.type,
        category: opportunity.category,
        requiredSkills: opportunity.requiredSkills,
        location: opportunity.location,
        isRemote: opportunity.isRemote,
        deadline: opportunity.deadline,
        compensation: opportunity.compensation,
        createdAt: opportunity.createdAt,
        updatedAt: opportunity.updatedAt,
        isActive: opportunity.isActive,
      );
      await docRef.set(withId.toFirestore());
      return withId;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<OpportunityModel> updateOpportunity(OpportunityModel opportunity) async {
    try {
      await _collection.doc(opportunity.id).update(opportunity.toFirestore());
      return opportunity;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> deleteOpportunity(String id) async {
    try {
      await _collection.doc(id).update({'isActive': false});
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }
}
