import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../applications/presentation/providers/application_providers.dart';
import '../../../profiles/presentation/providers/student_profile_providers.dart';
import '../../domain/entities/opportunity_entity.dart';
import 'opportunity_providers.dart';

typedef RecommendedOpportunity = ({
  OpportunityEntity opportunity,
  int matchPercent,
  List<String> matchedSkills,
});

/// A broad, unfiltered pool of active opportunities to score against — kept
/// independent of `opportunitiesStreamProvider`/`opportunityFilterProvider`
/// so a student's Discover-tab search/filter never affects what shows up
/// here.
final _recommendationCandidatesProvider =
    StreamProvider<List<OpportunityEntity>>((ref) {
  return ref.watch(opportunityRepositoryProvider).watchOpportunities(limit: 50);
});

/// Minimum match to bother showing — below this a recommendation is more
/// noise than signal (e.g. an empty-skills profile matching everything at 0%).
const _minMatchPercent = 30;

/// Scores each active, not-yet-applied-to opportunity against the student's
/// profile and returns the best matches, highest first.
///
/// The score is a transparent weighted blend, not a black box:
/// - 65% required-skills overlap (how many of the opportunity's
///   requiredSkills appear in the student's skills, case-insensitive).
/// - 20% location fit (remote opportunities always score full marks here;
///   otherwise a substring match between the student's and opportunity's
///   location strings).
/// - 15% interest fit (whether the opportunity's category name appears
///   anywhere in the student's career interests or bio).
final recommendedOpportunitiesProvider =
    Provider.family<AsyncValue<List<RecommendedOpportunity>>, String>((ref, studentId) {
  final profileAsync = ref.watch(studentProfileByOwnerProvider(studentId));
  final candidatesAsync = ref.watch(_recommendationCandidatesProvider);
  final applicationsAsync = ref.watch(applicantApplicationsProvider(studentId));

  if (profileAsync.isLoading || candidatesAsync.isLoading || applicationsAsync.isLoading) {
    return const AsyncLoading();
  }
  final erroring = profileAsync.hasError
      ? profileAsync
      : candidatesAsync.hasError
          ? candidatesAsync
          : applicationsAsync;
  if (erroring.hasError) {
    return AsyncError(erroring.error!, erroring.stackTrace ?? StackTrace.current);
  }

  final profile = profileAsync.requireValue;
  if (profile == null) return const AsyncData([]);

  final candidates = candidatesAsync.requireValue;
  final appliedIds =
      applicationsAsync.requireValue.map((a) => a.opportunityId).toSet();
  final studentSkills = profile.skills.map((s) => s.toLowerCase()).toSet();
  final interestText =
      '${profile.careerInterests} ${profile.bio}'.toLowerCase();

  final scored = <RecommendedOpportunity>[];
  for (final o in candidates) {
    if (!o.isActive || o.isExpired || appliedIds.contains(o.id)) continue;

    final matchedSkills = o.requiredSkills
        .where((skill) => studentSkills.contains(skill.toLowerCase()))
        .toList();
    final skillScore =
        o.requiredSkills.isEmpty ? 0.5 : matchedSkills.length / o.requiredSkills.length;

    final locationScore = o.isRemote
        ? 1.0
        : (profile.location.isNotEmpty &&
                (o.location.toLowerCase().contains(profile.location.toLowerCase()) ||
                    profile.location.toLowerCase().contains(o.location.toLowerCase())))
            ? 1.0
            : 0.2;

    final interestScore =
        interestText.isNotEmpty && interestText.contains(o.category.name.toLowerCase())
            ? 1.0
            : 0.4;

    final matchPercent =
        (skillScore * 0.65 + locationScore * 0.20 + interestScore * 0.15) * 100;

    if (matchPercent.round() < _minMatchPercent) continue;
    scored.add((
      opportunity: o,
      matchPercent: matchPercent.round(),
      matchedSkills: matchedSkills,
    ));
  }

  scored.sort((a, b) => b.matchPercent.compareTo(a.matchPercent));
  return AsyncData(scored.take(10).toList());
});
