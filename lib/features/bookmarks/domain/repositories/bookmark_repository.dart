abstract interface class BookmarkRepository {
  Stream<List<String>> watchBookmarkedIds(String userId);

  Future<void> addBookmark({
    required String userId,
    required String opportunityId,
  });

  Future<void> removeBookmark({
    required String userId,
    required String opportunityId,
  });

  Future<bool> isBookmarked({
    required String userId,
    required String opportunityId,
  });
}
