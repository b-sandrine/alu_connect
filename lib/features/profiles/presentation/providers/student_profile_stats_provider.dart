import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../applications/domain/entities/application_entity.dart';
import '../../../applications/presentation/providers/application_providers.dart';
import '../../../bookmarks/presentation/providers/bookmark_providers.dart';

typedef StudentProfileStats = ({
  int submitted,
  int shortlisted,
  int interviews,
  int accepted,
  int rejected,
  int saved,
});

/// Whether [app]'s history shows it ever reached [stage] or a later stage —
/// a progressive funnel count (e.g. an application later rejected after an
/// interview still counts toward "Interviews"), computed from
/// [ApplicationEntity.statusHistory] rather than the current status alone.
bool _everReached(ApplicationEntity app, ApplicationStatus stage) {
  final targetIndex = ApplicationEntity.pipelineStages.indexOf(stage);
  return app.statusHistory.any(
    (event) => ApplicationEntity.pipelineStages.indexOf(event.status) >= targetIndex,
  );
}

final studentProfileStatsProvider =
    Provider.family<AsyncValue<StudentProfileStats>, String>((ref, userId) {
  final applicationsAsync = ref.watch(applicantApplicationsProvider(userId));
  final bookmarksAsync = ref.watch(bookmarkedIdsProvider(userId));

  if (applicationsAsync.isLoading || bookmarksAsync.isLoading) {
    return const AsyncLoading();
  }
  final errored = applicationsAsync.hasError ? applicationsAsync : bookmarksAsync;
  if (errored.hasError) {
    return AsyncError(errored.error!, errored.stackTrace ?? StackTrace.current);
  }

  final applications = applicationsAsync.requireValue;
  final saved = bookmarksAsync.requireValue.length;

  return AsyncData((
    submitted: applications.length,
    shortlisted:
        applications.where((a) => _everReached(a, ApplicationStatus.screening)).length,
    interviews:
        applications.where((a) => _everReached(a, ApplicationStatus.interview)).length,
    accepted: applications.where((a) => a.isAccepted).length,
    rejected: applications.where((a) => a.isRejected).length,
    saved: saved,
  ));
});
