import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/datasources/startup_profile_remote_datasource.dart';
import '../../data/repositories/startup_profile_repository_impl.dart';
import '../../domain/entities/startup_profile_entity.dart';
import '../../domain/repositories/startup_profile_repository.dart';

final startupProfileRemoteDatasourceProvider =
    Provider<StartupProfileRemoteDatasource>((ref) {
  return StartupProfileRemoteDatasource(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

final startupProfileRepositoryProvider =
    Provider<StartupProfileRepository>((ref) {
  return StartupProfileRepositoryImpl(
    ref.watch(startupProfileRemoteDatasourceProvider),
  );
});

final startupProfileByOwnerProvider =
    StreamProvider.family<StartupProfileEntity?, String>((ref, ownerId) {
  return ref
      .watch(startupProfileRepositoryProvider)
      .watchProfileByOwnerId(ownerId);
});

class StartupProfileController
    extends AsyncNotifier<StartupProfileEntity?> {
  late StartupProfileRepository _repository;

  @override
  Future<StartupProfileEntity?> build() async {
    _repository = ref.watch(startupProfileRepositoryProvider);
    return null;
  }

  Future<void> saveProfile(StartupProfileEntity profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final existing =
          await _repository.getProfileByOwnerId(profile.ownerId);
      if (existing == null) {
        return _repository.createProfile(profile);
      } else {
        return _repository.updateProfile(
          StartupProfileEntity(
            id: existing.id,
            ownerId: profile.ownerId,
            companyName: profile.companyName,
            tagline: profile.tagline,
            description: profile.description,
            industry: profile.industry,
            location: profile.location,
            website: profile.website,
            logoUrl: existing.logoUrl,
            isVerified: existing.isVerified,
            founded: profile.founded,
            startupStage: profile.startupStage,
            companySize: profile.companySize,
            mission: profile.mission,
            vision: profile.vision,
            culture: profile.culture,
            createdAt: existing.createdAt,
            updatedAt: DateTime.now(),
          ),
        );
      }
    });
  }

  Future<void> uploadLogo(String profileId, Uint8List imageBytes) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadLogo(profileId, imageBytes);
      return state.value;
    });
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }
}

final startupProfileControllerProvider =
    AsyncNotifierProvider<StartupProfileController, StartupProfileEntity?>(
  StartupProfileController.new,
);
