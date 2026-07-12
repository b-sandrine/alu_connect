import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/datasources/student_profile_remote_datasource.dart';
import '../../data/repositories/student_profile_repository_impl.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/repositories/student_profile_repository.dart';

final studentProfileRemoteDatasourceProvider =
    Provider<StudentProfileRemoteDatasource>((ref) {
  return StudentProfileRemoteDatasource(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

final studentProfileRepositoryProvider =
    Provider<StudentProfileRepository>((ref) {
  return StudentProfileRepositoryImpl(
    ref.watch(studentProfileRemoteDatasourceProvider),
  );
});

final studentProfileByOwnerProvider =
    StreamProvider.family<StudentProfileEntity?, String>((ref, ownerId) {
  return ref
      .watch(studentProfileRepositoryProvider)
      .watchProfileByOwnerId(ownerId);
});

final studentProfilesByOwnerIdsProvider =
    FutureProvider.family<List<StudentProfileEntity>, List<String>>((ref, ownerIds) {
  return ref.watch(studentProfileRepositoryProvider).getProfilesByOwnerIds(ownerIds);
});

class StudentProfileController
    extends AsyncNotifier<StudentProfileEntity?> {
  late StudentProfileRepository _repository;

  @override
  Future<StudentProfileEntity?> build() async {
    _repository = ref.watch(studentProfileRepositoryProvider);
    return null;
  }

  Future<void> saveProfile(StudentProfileEntity profile) async {
    _log('saveProfile started for owner ${profile.ownerId}');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final existing = await _repository.getProfileByOwnerId(profile.ownerId);
      if (existing == null) {
        _log('saveProfile: creating new profile');
        return _repository.createProfile(profile);
      } else {
        _log('saveProfile: updating existing profile ${existing.id}');
        return _repository.updateProfile(
          StudentProfileEntity(
            id: existing.id,
            ownerId: profile.ownerId,
            photoUrl: existing.photoUrl,
            university: profile.university,
            degree: profile.degree,
            yearOfStudy: profile.yearOfStudy,
            location: profile.location,
            bio: profile.bio,
            careerInterests: profile.careerInterests,
            personalStatement: profile.personalStatement,
            skills: profile.skills,
            resumeUrl: existing.resumeUrl,
            resumeFileName: existing.resumeFileName,
            resumeUploadedAt: existing.resumeUploadedAt,
            portfolioUrl: profile.portfolioUrl,
            githubUrl: profile.githubUrl,
            linkedinUrl: profile.linkedinUrl,
            behanceUrl: profile.behanceUrl,
            dribbbleUrl: profile.dribbbleUrl,
            mediumUrl: profile.mediumUrl,
            personalWebsiteUrl: profile.personalWebsiteUrl,
            projects: existing.projects,
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

  Future<void> uploadPhoto(String profileId, Uint8List imageBytes) async {
    _log('uploadPhoto started for profile $profileId');
    // Captured before the AsyncLoading assignment below — state.value on a
    // bare AsyncLoading() is always null, so without this the controller's
    // cached profile would silently reset to null on every photo upload.
    final previous = state.valueOrNull;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadPhoto(profileId, imageBytes);
      return previous;
    });
    if (state.hasError) {
      _log('uploadPhoto FAILED: ${state.error}');
    } else {
      _log('uploadPhoto completed successfully');
    }
  }

  Future<void> uploadResume(
    String profileId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    _log('uploadResume started for profile $profileId');
    final previous = state.valueOrNull;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadResume(profileId, fileBytes, fileName);
      return previous;
    });
    if (state.hasError) {
      _log('uploadResume FAILED: ${state.error}');
    } else {
      _log('uploadResume completed successfully');
    }
  }

  Future<String> uploadProjectImage(
    String profileId,
    String projectId,
    String imageId,
    Uint8List imageBytes,
  ) =>
      _repository.uploadProjectImage(profileId, projectId, imageId, imageBytes);

  Future<void> updateProjects(
    StudentProfileEntity profile,
    List<ProjectEntity> projects,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateProfile(
        profile.copyWith(projects: projects, updatedAt: DateTime.now()),
      ),
    );
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[StudentProfileController] $message');
  }
}

final studentProfileControllerProvider =
    AsyncNotifierProvider<StudentProfileController, StudentProfileEntity?>(
  StudentProfileController.new,
);
