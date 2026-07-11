import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/datasources/opportunity_remote_datasource.dart';
import '../../data/repositories/opportunity_repository_impl.dart';
import '../../domain/entities/opportunity_entity.dart';
import '../../domain/repositories/opportunity_repository.dart';

final opportunityRemoteDatasourceProvider =
    Provider<OpportunityRemoteDatasource>((ref) {
  return OpportunityRemoteDatasource(firestore: FirebaseFirestore.instance);
});

final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  return OpportunityRepositoryImpl(
    ref.watch(opportunityRemoteDatasourceProvider),
  );
});

final opportunitiesByIdsProvider =
    FutureProvider.family<List<OpportunityEntity>, List<String>>((ref, ids) {
  return ref.watch(opportunityRepositoryProvider).getOpportunitiesByIds(ids);
});

final opportunitiesByStartupProvider =
    StreamProvider.family<List<OpportunityEntity>, String>((ref, startupId) {
  return ref
      .watch(opportunityRepositoryProvider)
      .watchOpportunitiesByStartup(startupId);
});

final opportunityFilterProvider =
    StateProvider<OpportunityFilter>((ref) => const OpportunityFilter());

/// How many "pages" worth of opportunities to request from Firestore.
/// Bumped by [loadMoreOpportunitiesProvider] instead of doing cursor-based
/// pagination — simpler to keep the list realtime (`.snapshots()`) while
/// still bounding reads to an explicit, user-driven limit rather than the
/// unbounded fetch-everything this replaced.
final _opportunityPageMultiplierProvider = StateProvider<int>((ref) => 1);

enum _PrimaryFilterField { none, type, category, isRemote }

/// Firestore needs a composite index per distinct filter+orderBy
/// combination. Supporting every combination of type/category/isRemote
/// server-side would need up to 8 indexes just for this screen, so only the
/// single highest-priority active filter is sent to Firestore; any other
/// active filters are applied client-side in [filteredOpportunitiesProvider]
/// on that already-small, already-filtered page.
_PrimaryFilterField _primaryServerFilter(OpportunityFilter filter) {
  if (filter.type != null) return _PrimaryFilterField.type;
  if (filter.category != null) return _PrimaryFilterField.category;
  if (filter.isRemote == true) return _PrimaryFilterField.isRemote;
  return _PrimaryFilterField.none;
}

final opportunitiesStreamProvider =
    StreamProvider<List<OpportunityEntity>>((ref) {
  final filter = ref.watch(opportunityFilterProvider);
  final multiplier = ref.watch(_opportunityPageMultiplierProvider);
  final primary = _primaryServerFilter(filter);
  final limit = AppConstants.opportunitiesPageSize * multiplier;

  return ref.watch(opportunityRepositoryProvider).watchOpportunities(
        type: primary == _PrimaryFilterField.type ? filter.type : null,
        category: primary == _PrimaryFilterField.category ? filter.category : null,
        isRemote: primary == _PrimaryFilterField.isRemote ? filter.isRemote : null,
        limit: limit,
      );
});

/// True once the last fetch returned a full page — a cheap heuristic for
/// "there may be more" without a separate count query.
final hasMoreOpportunitiesProvider = Provider<bool>((ref) {
  final multiplier = ref.watch(_opportunityPageMultiplierProvider);
  final limit = AppConstants.opportunitiesPageSize * multiplier;
  final count = ref.watch(opportunitiesStreamProvider).valueOrNull?.length ?? 0;
  return count >= limit;
});

void loadMoreOpportunities(WidgetRef ref) {
  ref.read(_opportunityPageMultiplierProvider.notifier).state++;
}

final filteredOpportunitiesProvider =
    Provider<AsyncValue<List<OpportunityEntity>>>((ref) {
  final filter = ref.watch(opportunityFilterProvider);
  final primary = _primaryServerFilter(filter);
  final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);

  return opportunitiesAsync.whenData((opportunities) {
    var filtered = opportunities.where((o) => !o.isExpired).toList();

    // Free-text search can't be done server-side by Firestore regardless of
    // index strategy, so it's always applied client-side.
    if (filter.query != null && filter.query!.isNotEmpty) {
      final q = filter.query!.toLowerCase();
      filtered = filtered
          .where((o) =>
              o.title.toLowerCase().contains(q) ||
              o.startupName.toLowerCase().contains(q) ||
              o.requiredSkills.any((s) => s.toLowerCase().contains(q)))
          .toList();
    }

    // Only apply a structured filter here if it *wasn't* already applied
    // server-side above.
    if (primary != _PrimaryFilterField.type && filter.type != null) {
      filtered = filtered.where((o) => o.type == filter.type).toList();
    }

    if (primary != _PrimaryFilterField.category && filter.category != null) {
      filtered = filtered.where((o) => o.category == filter.category).toList();
    }

    if (primary != _PrimaryFilterField.isRemote && filter.isRemote == true) {
      filtered = filtered.where((o) => o.isRemote).toList();
    }

    return filtered;
  });
});

class OpportunityController extends AsyncNotifier<void> {
  late OpportunityRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.watch(opportunityRepositoryProvider);
  }

  Future<void> createOpportunity(OpportunityEntity opportunity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.createOpportunity(opportunity),
    );
  }

  Future<void> updateOpportunity(OpportunityEntity opportunity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateOpportunity(opportunity),
    );
  }

  Future<void> deleteOpportunity(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.deleteOpportunity(id));
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }
}

final opportunityControllerProvider =
    AsyncNotifierProvider<OpportunityController, void>(
  OpportunityController.new,
);
