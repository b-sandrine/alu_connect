import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_remote_datasource.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl(this._datasource);

  final BookmarkRemoteDatasource _datasource;

  @override
  Stream<List<String>> watchBookmarkedIds(String userId) =>
      _datasource.watchBookmarkedIds(userId);

  @override
  Future<void> addBookmark({
    required String userId,
    required String opportunityId,
  }) =>
      _datasource.addBookmark(userId: userId, opportunityId: opportunityId);

  @override
  Future<void> removeBookmark({
    required String userId,
    required String opportunityId,
  }) =>
      _datasource.removeBookmark(userId: userId, opportunityId: opportunityId);

  @override
  Future<bool> isBookmarked({
    required String userId,
    required String opportunityId,
  }) =>
      _datasource.isBookmarked(userId: userId, opportunityId: opportunityId);
}
