import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../applications/presentation/providers/application_providers.dart';
import '../../../opportunities/presentation/providers/opportunity_providers.dart';
import '../../../profiles/presentation/providers/student_profile_providers.dart';

typedef MonthlyCount = ({String month, int count});
typedef OpportunityViews = ({String title, int views, int applications});
typedef SkillCount = ({String skill, int count});
typedef LocationCount = ({String location, int count});

typedef StartupAnalytics = ({
  int totalOpportunities,
  int totalApplications,
  int totalViews,
  double acceptanceRate,
  List<MonthlyCount> applicationsPerMonth,
  List<OpportunityViews> topOpportunities,
});

/// Core analytics derived purely from the opportunities/applications
/// streams that already power the dashboard — no extra reads.
final startupAnalyticsProvider =
    Provider.family<AsyncValue<StartupAnalytics>, String>((ref, startupId) {
  final opportunitiesAsync = ref.watch(opportunitiesByStartupProvider(startupId));
  final applicationsAsync = ref.watch(startupApplicationsProvider(startupId));

  if (opportunitiesAsync.isLoading || applicationsAsync.isLoading) {
    return const AsyncLoading();
  }
  final erroring = opportunitiesAsync.hasError ? opportunitiesAsync : applicationsAsync;
  if (erroring.hasError) {
    return AsyncError(erroring.error!, erroring.stackTrace ?? StackTrace.current);
  }

  final opportunities = opportunitiesAsync.requireValue;
  final applications = applicationsAsync.requireValue;

  final now = DateTime.now();
  final months = [for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i)];
  String monthKey(DateTime d) => DateFormat('yyyy-MM').format(d);
  final counts = {for (final m in months) monthKey(m): 0};
  for (final a in applications) {
    final key = monthKey(a.appliedAt);
    if (counts.containsKey(key)) counts[key] = counts[key]! + 1;
  }
  final applicationsPerMonth = [
    for (final m in months)
      (month: DateFormat('MMM').format(m), count: counts[monthKey(m)]!),
  ];

  final appCountByOpportunity = <String, int>{};
  for (final a in applications) {
    appCountByOpportunity[a.opportunityId] =
        (appCountByOpportunity[a.opportunityId] ?? 0) + 1;
  }
  final sortedByViews = [...opportunities]
    ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
  final topOpportunities = sortedByViews
      .take(5)
      .map((o) => (
            title: o.title,
            views: o.viewCount,
            applications: appCountByOpportunity[o.id] ?? 0,
          ))
      .toList();

  final accepted = applications.where((a) => a.isAccepted).length;
  final rejected = applications.where((a) => a.isRejected).length;
  final terminal = accepted + rejected;
  final acceptanceRate = terminal == 0 ? 0.0 : accepted / terminal;
  final totalViews = opportunities.fold<int>(0, (sum, o) => sum + o.viewCount);

  return AsyncData((
    totalOpportunities: opportunities.length,
    totalApplications: applications.length,
    totalViews: totalViews,
    acceptanceRate: acceptanceRate,
    applicationsPerMonth: applicationsPerMonth,
    topOpportunities: topOpportunities,
  ));
});

/// Aggregated skills/locations across every applicant to this startup's
/// postings — requires a batch fetch of student profiles, so it's kept
/// separate from [startupAnalyticsProvider] and loads independently.
final applicantInsightsProvider = Provider.family<
    AsyncValue<({List<SkillCount> topSkills, List<LocationCount> locations})>,
    String>((ref, startupId) {
  final applicationsAsync = ref.watch(startupApplicationsProvider(startupId));
  if (applicationsAsync.isLoading) return const AsyncLoading();
  if (applicationsAsync.hasError) {
    return AsyncError(
      applicationsAsync.error!,
      applicationsAsync.stackTrace ?? StackTrace.current,
    );
  }

  final applicantIds =
      applicationsAsync.requireValue.map((a) => a.applicantId).toSet().toList();
  final profilesAsync = ref.watch(studentProfilesByOwnerIdsProvider(applicantIds));

  return profilesAsync.whenData((profiles) {
    final skillCounts = <String, int>{};
    final locationCounts = <String, int>{};
    for (final p in profiles) {
      for (final skill in p.skills) {
        skillCounts[skill] = (skillCounts[skill] ?? 0) + 1;
      }
      if (p.location.isNotEmpty) {
        locationCounts[p.location] = (locationCounts[p.location] ?? 0) + 1;
      }
    }

    final topSkills = skillCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final locations = locationCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return (
      topSkills: topSkills
          .take(8)
          .map((e) => (skill: e.key, count: e.value))
          .toList(),
      locations: locations
          .take(6)
          .map((e) => (location: e.key, count: e.value))
          .toList(),
    );
  });
});
