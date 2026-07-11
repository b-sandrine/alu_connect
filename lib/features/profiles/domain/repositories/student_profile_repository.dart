import 'dart:typed_data';

import '../entities/student_profile_entity.dart';

abstract interface class StudentProfileRepository {
  Future<StudentProfileEntity?> getProfileByOwnerId(String ownerId);

  Future<StudentProfileEntity> createProfile(StudentProfileEntity profile);

  Future<StudentProfileEntity> updateProfile(StudentProfileEntity profile);

  Future<String> uploadPhoto(String profileId, Uint8List imageBytes);

  Stream<StudentProfileEntity?> watchProfileByOwnerId(String ownerId);
}
