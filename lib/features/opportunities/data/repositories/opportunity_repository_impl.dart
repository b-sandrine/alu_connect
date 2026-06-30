import '../../domain/entities/opportunity_entity.dart';
import '../../domain/repositories/opportunity_repository.dart';
import '../datasources/opportunity_remote_datasource.dart';
import '../models/opportunity_model.dart';

class OpportunityRepositoryImpl implements OpportunityRepository {
  const OpportunityRepositoryImpl(this._datasource);

  final OpportunityRemoteDatasource _datasource;

  @override
  Stream<List<OpportunityEntity>> watchOpportunities() =>
      _datasource.watchOpportunities();

  @override
  Stream<List<OpportunityEntity>> watchOpportunitiesByStartup(String startupId) =>
      _datasource.watchOpportunitiesByStartup(startupId);

  @override
  Future<OpportunityEntity> getOpportunityById(String id) =>
      _datasource.getOpportunityById(id);

  @override
  Future<OpportunityEntity> createOpportunity(OpportunityEntity opportunity) =>
      _datasource.createOpportunity(_toModel(opportunity));

  @override
  Future<OpportunityEntity> updateOpportunity(OpportunityEntity opportunity) =>
      _datasource.updateOpportunity(_toModel(opportunity));

  @override
  Future<void> deleteOpportunity(String id) =>
      _datasource.deleteOpportunity(id);

  OpportunityModel _toModel(OpportunityEntity e) {
    return OpportunityModel(
      id: e.id,
      startupId: e.startupId,
      startupName: e.startupName,
      startupLogoUrl: e.startupLogoUrl,
      title: e.title,
      description: e.description,
      type: e.type,
      category: e.category,
      requiredSkills: e.requiredSkills,
      location: e.location,
      isRemote: e.isRemote,
      deadline: e.deadline,
      compensation: e.compensation,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      isActive: e.isActive,
    );
  }
}
