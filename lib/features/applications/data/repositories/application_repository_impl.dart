import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/application_remote_datasource.dart';
import '../models/application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  const ApplicationRepositoryImpl(this._datasource);

  final ApplicationRemoteDatasource _datasource;

  @override
  Future<ApplicationEntity> submitApplication(ApplicationEntity application) =>
      _datasource.submitApplication(_toModel(application));

  @override
  Future<bool> hasApplied({
    required String applicantId,
    required String opportunityId,
  }) =>
      _datasource.hasApplied(
        applicantId: applicantId,
        opportunityId: opportunityId,
      );

  @override
  Stream<List<ApplicationEntity>> watchApplicationsByApplicant(
          String applicantId) =>
      _datasource.watchApplicationsByApplicant(applicantId);

  @override
  Stream<List<ApplicationEntity>> watchApplicationsByOpportunity(
          String opportunityId) =>
      _datasource.watchApplicationsByOpportunity(opportunityId);

  @override
  Stream<List<ApplicationEntity>> watchApplicationsByStartup(String startupId) =>
      _datasource.watchApplicationsByStartup(startupId);

  @override
  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? reviewNote,
  }) =>
      _datasource.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
        reviewNote: reviewNote,
      );

  ApplicationModel _toModel(ApplicationEntity e) {
    return ApplicationModel(
      id: e.id,
      opportunityId: e.opportunityId,
      opportunityTitle: e.opportunityTitle,
      startupId: e.startupId,
      startupName: e.startupName,
      applicantId: e.applicantId,
      applicantName: e.applicantName,
      coverLetter: e.coverLetter,
      status: e.status,
      appliedAt: e.appliedAt,
      reviewedAt: e.reviewedAt,
      reviewNote: e.reviewNote,
    );
  }
}
