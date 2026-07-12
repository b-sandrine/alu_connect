import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/application_remote_datasource.dart';
import '../models/application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  const ApplicationRepositoryImpl(this._datasource);

  final ApplicationRemoteDatasource _datasource;

  @override
  Future<ApplicationEntity> submitApplication(ApplicationEntity application) async {
    final model = await _datasource.submitApplication(
      ApplicationModel.fromEntity(application),
    );
    return model.toEntity();
  }

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
      _datasource
          .watchApplicationsByApplicant(applicantId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<ApplicationEntity>> watchApplicationsByOpportunity(
          String opportunityId) =>
      _datasource
          .watchApplicationsByOpportunity(opportunityId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<ApplicationEntity>> watchApplicationsByStartup(String startupId) =>
      _datasource
          .watchApplicationsByStartup(startupId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? reviewNote,
    DateTime? interviewScheduledAt,
    String? interviewLocation,
    String? meetingLink,
    String? interviewNotes,
    String? offerNote,
  }) =>
      _datasource.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
        reviewNote: reviewNote,
        interviewScheduledAt: interviewScheduledAt,
        interviewLocation: interviewLocation,
        meetingLink: meetingLink,
        interviewNotes: interviewNotes,
        offerNote: offerNote,
      );
}
