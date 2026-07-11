import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/firebase_error_mapper.dart';

class BookmarkRemoteDatasource {
  const BookmarkRemoteDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  // One subcollection doc per bookmarked opportunity (doc ID = opportunityId)
  // rather than one array-in-doc per user — lets "how many users bookmarked
  // opportunity X" be answered via a collectionGroup query instead of being
  // structurally impossible.
  CollectionReference<Map<String, dynamic>> _userBookmarks(String userId) =>
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.bookmarksCollection);

  // Legacy array-in-doc location, kept read-only here purely so
  // [migrateLegacyBookmarksIfNeeded] can lift a user's old data into the new
  // subcollection the first time they're seen after this change shipped.
  DocumentReference<Map<String, dynamic>> _legacyDoc(String userId) =>
      _firestore.collection(AppConstants.bookmarksCollection).doc(userId);

  Stream<List<String>> watchBookmarkedIds(String userId) {
    return _userBookmarks(userId)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toList());
  }

  Future<void> addBookmark({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      await _userBookmarks(userId).doc(opportunityId).set({
        'opportunityId': opportunityId,
        'createdAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> removeBookmark({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      await _userBookmarks(userId).doc(opportunityId).delete();
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<bool> isBookmarked({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      final doc = await _userBookmarks(userId).doc(opportunityId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  /// How many users have bookmarked this opportunity — powers the
  /// "Bookmarks" stat on the startup's Postings list.
  Future<int> getBookmarkCount(String opportunityId) async {
    try {
      final aggregate = await _firestore
          .collectionGroup(AppConstants.bookmarksCollection)
          .where('opportunityId', isEqualTo: opportunityId)
          .count()
          .get();
      return aggregate.count ?? 0;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  /// One-time, idempotent lift of a user's old `bookmarks/{uid}.opportunityIds`
  /// array into the new subcollection. Safe to call on every sign-in: it
  /// no-ops once the subcollection already has data.
  Future<void> migrateLegacyBookmarksIfNeeded(String userId) async {
    try {
      final existing = await _userBookmarks(userId).limit(1).get();
      if (existing.docs.isNotEmpty) return;

      final legacy = await _legacyDoc(userId).get();
      if (!legacy.exists) return;
      final ids = List<String>.from(
        legacy.data()?['opportunityIds'] as List? ?? [],
      );
      if (ids.isEmpty) return;

      final batch = _firestore.batch();
      final now = Timestamp.now();
      for (final id in ids) {
        batch.set(_userBookmarks(userId).doc(id), {
          'opportunityId': id,
          'createdAt': now,
        });
      }
      await batch.commit();
    } on FirebaseException {
      // Best-effort — migration failures must never block sign-in.
    }
  }
}
