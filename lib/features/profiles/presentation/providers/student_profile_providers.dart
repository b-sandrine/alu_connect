import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final existing = await _repository.getProfileByOwnerId(profile.ownerId);
      if (existing == null) {
        return _repository.createProfile(profile);
      } else {
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
            createdAt: existing.createdAt,
            updatedAt: DateTime.now(),
          ),
        );
      }
    });
  }

  Future<void> uploadPhoto(String profileId, Uint8List imageBytes) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadPhoto(profileId, imageBytes);
      return state.value;
    });
  }

  Future<void> uploadResume(
    String profileId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.uploadResume(profileId, fileBytes, fileName);
      return state.value;
    });
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }
}

final studentProfileControllerProvider =
    AsyncNotifierProvider<StudentProfileController, StudentProfileEntity?>(
  StudentProfileController.new,
);
