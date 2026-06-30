import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/firebase_error_mapper.dart';

class BookmarkRemoteDatasource {
  const BookmarkRemoteDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  // Each user has one bookmark document holding an array of opportunity IDs.
  DocumentReference<Map<String, dynamic>> _userBookmarkDoc(String userId) =>
      _firestore.collection(AppConstants.bookmarksCollection).doc(userId);

  Stream<List<String>> watchBookmarkedIds(String userId) {
    return _userBookmarkDoc(userId).snapshots().map((doc) {
      if (!doc.exists) return <String>[];
      final data = doc.data();
      if (data == null) return <String>[];
      return List<String>.from(data['opportunityIds'] as List? ?? []);
    });
  }

  Future<void> addBookmark({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      await _userBookmarkDoc(userId).set(
        {
          'opportunityIds': FieldValue.arrayUnion([opportunityId]),
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> removeBookmark({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      await _userBookmarkDoc(userId).update({
        'opportunityIds': FieldValue.arrayRemove([opportunityId]),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<bool> isBookmarked({
    required String userId,
    required String opportunityId,
  }) async {
    try {
      final doc = await _userBookmarkDoc(userId).get();
      if (!doc.exists) return false;
      final ids = List<String>.from(doc.data()?['opportunityIds'] as List? ?? []);
      return ids.contains(opportunityId);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }
}
