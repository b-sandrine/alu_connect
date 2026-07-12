import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
    _log('saveProfile started for owner ${profile.ownerId}');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final existing =
          await _repository.getProfileByOwnerId(profile.ownerId);
      if (existing == null) {
        _log('saveProfile: creating new profile');
        return _repository.createProfile(profile);
      } else {
        _log('saveProfile: updating existing profile ${existing.id}');
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
            founders: existing.founders,
            teamMembers: existing.teamMembers,
            galleryImages: existing.galleryImages,
            createdAt: existing.createdAt,
            updatedAt: DateTime.now(),
          ),
        );
      }
    });
    if (state.hasError) {
      _log('saveProfile FAILED: ${state.error}');
    } else {
      _log('saveProfile completed successfully');
    }
  }

  Future<void> uploadLogo(String profileId, Uint8List imageBytes) async {
    _log('uploadLogo started for profile $profileId');
    // Captured before the AsyncLoading assignment below — state.value on a
    // bare AsyncLoading() is always null, so without this the controller's
    // cached profile would silently reset to null on every logo upload.
    final previous = state.valueOrNull;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadLogo(profileId, imageBytes);
      return previous;
    });
    if (state.hasError) {
      _log('uploadLogo FAILED: ${state.error}');
    } else {
      _log('uploadLogo completed successfully');
    }
  }

  Future<String> uploadFounderPhoto(
    String profileId,
    String founderId,
    Uint8List imageBytes,
  ) =>
      _repository.uploadFounderPhoto(profileId, founderId, imageBytes);

  Future<String> uploadTeamMemberPhoto(
    String profileId,
    String memberId,
    Uint8List imageBytes,
  ) =>
      _repository.uploadTeamMemberPhoto(profileId, memberId, imageBytes);

  Future<String> uploadGalleryImage(
    String profileId,
    String imageId,
    Uint8List imageBytes,
  ) =>
      _repository.uploadGalleryImage(profileId, imageId, imageBytes);

  Future<void> updateFounders(
    StartupProfileEntity profile,
    List<FounderEntity> founders,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateProfile(
        profile.copyWith(founders: founders, updatedAt: DateTime.now()),
      ),
    );
  }

  Future<void> updateTeamMembers(
    StartupProfileEntity profile,
    List<TeamMemberEntity> teamMembers,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateProfile(
        profile.copyWith(teamMembers: teamMembers, updatedAt: DateTime.now()),
      ),
    );
  }

  Future<void> updateGalleryImages(
    StartupProfileEntity profile,
    List<GalleryImageEntity> galleryImages,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateProfile(
        profile.copyWith(galleryImages: galleryImages, updatedAt: DateTime.now()),
      ),
    );
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[StartupProfileController] $message');
  }
}

final startupProfileControllerProvider =
    AsyncNotifierProvider<StartupProfileController, StartupProfileEntity?>(
  StartupProfileController.new,
);
