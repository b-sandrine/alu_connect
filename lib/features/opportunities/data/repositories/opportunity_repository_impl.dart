import '../../domain/entities/opportunity_entity.dart';
import '../../domain/repositories/opportunity_repository.dart';
import '../datasources/opportunity_remote_datasource.dart';
import '../models/opportunity_model.dart';

class OpportunityRepositoryImpl implements OpportunityRepository {
  const OpportunityRepositoryImpl(this._datasource);

  final OpportunityRemoteDatasource _datasource;

  @override
  Stream<List<OpportunityEntity>> watchOpportunities({
    OpportunityType? type,
    OpportunityCategory? category,
    bool? isRemote,
    required int limit,
  }) =>
      _datasource
          .watchOpportunities(
            type: type,
            category: category,
            isRemote: isRemote,
            limit: limit,
          )
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<OpportunityEntity>> watchOpportunitiesByStartup(String startupId) =>
      _datasource
          .watchOpportunitiesByStartup(startupId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Future<OpportunityEntity> getOpportunityById(String id) async {
    final model = await _datasource.getOpportunityById(id);
    return model.toEntity();
  }

  @override
  Future<List<OpportunityEntity>> getOpportunitiesByIds(List<String> ids) async {
    final models = await _datasource.getOpportunitiesByIds(ids);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<OpportunityEntity> createOpportunity(OpportunityEntity opportunity) async {
    final model = await _datasource.createOpportunity(
      OpportunityModel.fromEntity(opportunity),
    );
    return model.toEntity();
  }

  @override
  Future<OpportunityEntity> updateOpportunity(OpportunityEntity opportunity) async {
    final model = await _datasource.updateOpportunity(
      OpportunityModel.fromEntity(opportunity),
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteOpportunity(String id) =>
      _datasource.deleteOpportunity(id);

  @override
  Future<void> incrementViewCount(String id) =>
      _datasource.incrementViewCount(id);
}
