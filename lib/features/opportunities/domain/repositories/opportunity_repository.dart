import '../entities/opportunity_entity.dart';

abstract interface class OpportunityRepository {
  Stream<List<OpportunityEntity>> watchOpportunities();

  Stream<List<OpportunityEntity>> watchOpportunitiesByStartup(String startupId);

  Future<OpportunityEntity> getOpportunityById(String id);

  Future<OpportunityEntity> createOpportunity(OpportunityEntity opportunity);

  Future<OpportunityEntity> updateOpportunity(OpportunityEntity opportunity);

  Future<void> deleteOpportunity(String id);
}
