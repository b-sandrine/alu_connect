import '../entities/application_entity.dart';

abstract interface class ApplicationRepository {
  // Checks for existing application before creating — prevents duplicates
  Future<ApplicationEntity> submitApplication(ApplicationEntity application);

  Future<bool> hasApplied({
    required String applicantId,
    required String opportunityId,
  });

  Stream<List<ApplicationEntity>> watchApplicationsByApplicant(String applicantId);

  Stream<List<ApplicationEntity>> watchApplicationsByOpportunity(String opportunityId);

  Stream<List<ApplicationEntity>> watchApplicationsByStartup(String startupId);

  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? reviewNote,
    DateTime? interviewScheduledAt,
    String? interviewLocation,
    String? interviewNotes,
    String? offerNote,
  });
}
