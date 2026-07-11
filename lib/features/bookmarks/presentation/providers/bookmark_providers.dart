import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../data/datasources/bookmark_remote_datasource.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/repositories/bookmark_repository.dart';

final bookmarkRemoteDatasourceProvider =
    Provider<BookmarkRemoteDatasource>((ref) {
  return BookmarkRemoteDatasource(firestore: FirebaseFirestore.instance);
});

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(ref.watch(bookmarkRemoteDatasourceProvider));
});

final bookmarkedIdsProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  return ref.watch(bookmarkRepositoryProvider).watchBookmarkedIds(userId);
});

final isBookmarkedProvider =
    FutureProvider.family<bool, ({String userId, String opportunityId})>(
  (ref, args) => ref.watch(bookmarkRepositoryProvider).isBookmarked(
        userId: args.userId,
        opportunityId: args.opportunityId,
      ),
);

class BookmarkController extends AsyncNotifier<void> {
  late BookmarkRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.watch(bookmarkRepositoryProvider);
  }

  Future<void> toggle({
    required String userId,
    required String opportunityId,
  }) async {
    final isCurrentlyBookmarked = await _repository.isBookmarked(
      userId: userId,
      opportunityId: opportunityId,
    );

    if (isCurrentlyBookmarked) {
      await _repository.removeBookmark(
          userId: userId, opportunityId: opportunityId);
    } else {
      await _repository.addBookmark(
          userId: userId, opportunityId: opportunityId);
    }

    unawaited(ref.read(analyticsServiceProvider).logBookmarkToggle(
          opportunityId: opportunityId,
          added: !isCurrentlyBookmarked,
        ));

    ref.invalidate(bookmarkedIdsProvider(userId));
    ref.invalidate(
      isBookmarkedProvider((userId: userId, opportunityId: opportunityId)),
    );
  }
}

final bookmarkControllerProvider =
    AsyncNotifierProvider<BookmarkController, void>(BookmarkController.new);
