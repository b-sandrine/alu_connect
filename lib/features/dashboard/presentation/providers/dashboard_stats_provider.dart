import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../applications/presentation/providers/application_providers.dart';
import '../../../opportunities/presentation/providers/opportunity_providers.dart';

typedef StartupDashboardStats = ({
  int totalPostings,
  int totalApplicants,
  int pendingReview,
});

final startupDashboardStatsProvider =
    Provider.family<AsyncValue<StartupDashboardStats>, String>((ref, startupId) {
  final opportunitiesAsync = ref.watch(opportunitiesByStartupProvider(startupId));
  final applicationsAsync = ref.watch(startupApplicationsProvider(startupId));

  if (opportunitiesAsync.isLoading || applicationsAsync.isLoading) {
    return const AsyncLoading();
  }
  final error = opportunitiesAsync.hasError ? opportunitiesAsync : applicationsAsync;
  if (error.hasError) {
    return AsyncError(error.error!, error.stackTrace ?? StackTrace.current);
  }

  final opportunities = opportunitiesAsync.requireValue;
  final applications = applicationsAsync.requireValue;

  return AsyncData((
    totalPostings: opportunities.length,
    totalApplicants: applications.length,
    pendingReview: applications.where((a) => a.isPending).length,
  ));
});
