import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../opportunities/domain/entities/opportunity_entity.dart';
import '../../../opportunities/presentation/providers/opportunity_providers.dart';
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

final bookmarkCountProvider = FutureProvider.family<int, String>((ref, opportunityId) {
  return ref.watch(bookmarkRepositoryProvider).getBookmarkCount(opportunityId);
});

/// Joins the user's bookmarked IDs against actual opportunity data — backs
/// the dashboard's Saved Opportunities section.
final savedOpportunitiesProvider =
    Provider.family<AsyncValue<List<OpportunityEntity>>, String>((ref, userId) {
  final idsAsync = ref.watch(bookmarkedIdsProvider(userId));
  return idsAsync.when(
    data: (ids) {
      if (ids.isEmpty) return const AsyncData([]);
      return ref.watch(opportunitiesByIdsProvider(ids));
    },
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});

/// Self-managing, mirrors `presenceHeartbeatProvider`: watch once from the
/// app root. Lifts each newly-seen user's legacy bookmark array into the
/// subcollection structure exactly once per sign-in.
final bookmarkMigrationProvider = Provider<void>((ref) {
  String? migratedUserId;

  ref.listen(authStateProvider, (previous, next) {
    final user = next.valueOrNull;
    if (user == null || migratedUserId == user.id) return;
    migratedUserId = user.id;
    ref.read(bookmarkRepositoryProvider).migrateLegacyBookmarksIfNeeded(user.id);
  }, fireImmediately: true);
});

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
