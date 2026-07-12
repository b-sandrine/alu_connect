import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../../domain/entities/opportunity_entity.dart';
import '../models/opportunity_model.dart';

class OpportunityRemoteDatasource {
  const OpportunityRemoteDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.opportunitiesCollection);

  Stream<List<OpportunityModel>> watchOpportunities({
    OpportunityType? type,
    OpportunityCategory? category,
    bool? isRemote,
    required int limit,
  }) {
    Query<Map<String, dynamic>> query =
        _collection.where('isActive', isEqualTo: true);
    if (type != null) query = query.where('type', isEqualTo: type.name);
    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }
    if (isRemote != null) query = query.where('isRemote', isEqualTo: isRemote);

    return query
        .orderBy('createdAt', descending: true)
        .limit(limit)
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

  /// Fetches exactly the given opportunities by ID (e.g. a user's bookmarks)
  /// instead of relying on the paginated discovery feed, so a bookmark never
  /// silently disappears just because it isn't on the current page.
  /// Firestore's `whereIn` caps at 30 values per query, so this chunks.
  Future<List<OpportunityModel>> getOpportunitiesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      final chunks = <List<String>>[
        for (var i = 0; i < ids.length; i += 30)
          ids.sublist(i, i + 30 > ids.length ? ids.length : i + 30),
      ];
      final snapshots = await Future.wait(
        chunks.map(
          (chunk) => _collection.where(FieldPath.documentId, whereIn: chunk).get(),
        ),
      );
      return snapshots
          .expand((snap) => snap.docs)
          .map(OpportunityModel.fromFirestore)
          .toList();
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

  Future<void> incrementViewCount(String id) async {
    try {
      await _collection.doc(id).update({'viewCount': FieldValue.increment(1)});
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  // users/{uid}/recently_viewed/{opportunityId} — doc ID = opportunityId so
  // re-viewing the same opportunity just bumps its timestamp instead of
  // creating a duplicate entry.
  CollectionReference<Map<String, dynamic>> _recentlyViewed(String userId) =>
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.recentlyViewedCollection);

  Future<void> recordRecentlyViewed(String userId, String opportunityId) async {
    try {
      await _recentlyViewed(userId).doc(opportunityId).set({
        'opportunityId': opportunityId,
        'viewedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Stream<List<({String opportunityId, DateTime viewedAt})>> watchRecentlyViewed(
    String userId, {
    int limit = 10,
  }) {
    return _recentlyViewed(userId)
        .orderBy('viewedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => (
                  opportunityId: d.id,
                  viewedAt: (d.data()['viewedAt'] as Timestamp).toDate(),
                ))
            .toList());
  }
}
