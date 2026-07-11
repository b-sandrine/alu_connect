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

  /// How many users have bookmarked this opportunity.
  Future<int> getBookmarkCount(String opportunityId);

  /// One-time lift of a user's legacy array-in-doc bookmarks into the
  /// current subcollection structure. Safe to call repeatedly.
  Future<void> migrateLegacyBookmarksIfNeeded(String userId);
}
