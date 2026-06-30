import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final opportunitiesStreamProvider =
    StreamProvider<List<OpportunityEntity>>((ref) {
  return ref.watch(opportunityRepositoryProvider).watchOpportunities();
});

final opportunitiesByStartupProvider =
    StreamProvider.family<List<OpportunityEntity>, String>((ref, startupId) {
  return ref
      .watch(opportunityRepositoryProvider)
      .watchOpportunitiesByStartup(startupId);
});

// Client-side filter applied on top of the Firestore stream
final opportunityFilterProvider =
    StateProvider<OpportunityFilter>((ref) => const OpportunityFilter());

final filteredOpportunitiesProvider =
    Provider<AsyncValue<List<OpportunityEntity>>>((ref) {
  final filter = ref.watch(opportunityFilterProvider);
  final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);

  return opportunitiesAsync.whenData((opportunities) {
    var filtered = opportunities.where((o) => !o.isExpired).toList();

    if (filter.query != null && filter.query!.isNotEmpty) {
      final q = filter.query!.toLowerCase();
      filtered = filtered
          .where((o) =>
              o.title.toLowerCase().contains(q) ||
              o.startupName.toLowerCase().contains(q) ||
              o.requiredSkills.any((s) => s.toLowerCase().contains(q)))
          .toList();
    }

    if (filter.type != null) {
      filtered = filtered.where((o) => o.type == filter.type).toList();
    }

    if (filter.category != null) {
      filtered = filtered.where((o) => o.category == filter.category).toList();
    }

    if (filter.isRemote == true) {
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
