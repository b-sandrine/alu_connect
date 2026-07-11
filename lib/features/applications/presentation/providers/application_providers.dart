import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/datasources/application_remote_datasource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';

final applicationRemoteDatasourceProvider =
    Provider<ApplicationRemoteDatasource>((ref) {
  return ApplicationRemoteDatasource(firestore: FirebaseFirestore.instance);
});

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepositoryImpl(
    ref.watch(applicationRemoteDatasourceProvider),
  );
});

final applicantApplicationsProvider =
    StreamProvider.family<List<ApplicationEntity>, String>((ref, applicantId) {
  return ref
      .watch(applicationRepositoryProvider)
      .watchApplicationsByApplicant(applicantId);
});

final opportunityApplicationsProvider =
    StreamProvider.family<List<ApplicationEntity>, String>((ref, opportunityId) {
  return ref
      .watch(applicationRepositoryProvider)
      .watchApplicationsByOpportunity(opportunityId);
});

final startupApplicationsProvider =
    StreamProvider.family<List<ApplicationEntity>, String>((ref, startupId) {
  return ref
      .watch(applicationRepositoryProvider)
      .watchApplicationsByStartup(startupId);
});

typedef ApplicationStats = ({int total, int pending, int accepted});

final applicantApplicationStatsProvider =
    Provider.family<AsyncValue<ApplicationStats>, String>((ref, applicantId) {
  final applicationsAsync = ref.watch(applicantApplicationsProvider(applicantId));
  return applicationsAsync.whenData((applications) {
    return (
      total: applications.length,
      pending: applications.where((a) => a.isPending).length,
      accepted: applications.where((a) => a.isAccepted).length,
    );
  });
});

final hasAppliedProvider =
    FutureProvider.family<bool, ({String applicantId, String opportunityId})>(
  (ref, args) => ref.watch(applicationRepositoryProvider).hasApplied(
        applicantId: args.applicantId,
        opportunityId: args.opportunityId,
      ),
);

class ApplicationController extends AsyncNotifier<void> {
  late ApplicationRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.watch(applicationRepositoryProvider);
  }

  Future<void> submitApplication(ApplicationEntity application) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.submitApplication(application),
    );
    if (!state.hasError) {
      unawaited(ref.read(analyticsServiceProvider).logApply(application.opportunityId));
    }
  }

  Future<void> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
    String? reviewNote,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
        reviewNote: reviewNote,
      ),
    );
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }
}

final applicationControllerProvider =
    AsyncNotifierProvider<ApplicationController, void>(
  ApplicationController.new,
);
