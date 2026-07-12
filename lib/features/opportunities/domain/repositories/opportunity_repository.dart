import '../entities/opportunity_entity.dart';

abstract interface class OpportunityRepository {
  /// Streams active opportunities, newest first. At most one of [type],
  /// [category], [isRemote] should be non-null — the caller is responsible
  /// for picking a single primary server-side filter (see
  /// opportunity_providers.dart) so this only ever needs the small, fixed
  /// set of composite indexes declared in firestore.indexes.json instead of
  /// one per possible filter combination.
  Stream<List<OpportunityEntity>> watchOpportunities({
    OpportunityType? type,
    OpportunityCategory? category,
    bool? isRemote,
    required int limit,
  });

  Stream<List<OpportunityEntity>> watchOpportunitiesByStartup(String startupId);

  Future<OpportunityEntity> getOpportunityById(String id);

  /// Fetches exactly the given opportunities by ID — used for bookmarks,
  /// which must never depend on [watchOpportunities]'s pagination window.
  Future<List<OpportunityEntity>> getOpportunitiesByIds(List<String> ids);

  Future<OpportunityEntity> createOpportunity(OpportunityEntity opportunity);

  Future<OpportunityEntity> updateOpportunity(OpportunityEntity opportunity);

  Future<void> deleteOpportunity(String id);

  /// Fire-and-forget view counter, incremented when a student opens an
  /// opportunity's detail screen — backs the "Most viewed" analytics chart.
  Future<void> incrementViewCount(String id);

  /// Records that a student viewed this opportunity just now — backs their
  /// personal "Recently Viewed" list. Separate from [incrementViewCount],
  /// which is an aggregate counter with no per-user history.
  Future<void> recordRecentlyViewed(String userId, String opportunityId);

  Stream<List<({String opportunityId, DateTime viewedAt})>> watchRecentlyViewed(
    String userId, {
    int limit = 10,
  });
}
