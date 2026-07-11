import 'dart:typed_data';

import '../../domain/entities/student_profile_entity.dart';
import '../../domain/repositories/student_profile_repository.dart';
import '../datasources/student_profile_remote_datasource.dart';
import '../models/student_profile_model.dart';

class StudentProfileRepositoryImpl implements StudentProfileRepository {
  const StudentProfileRepositoryImpl(this._datasource);

  final StudentProfileRemoteDatasource _datasource;

  @override
  Future<StudentProfileEntity?> getProfileByOwnerId(String ownerId) async {
    final model = await _datasource.getProfileByOwnerId(ownerId);
    return model?.toEntity();
  }

  @override
  Future<StudentProfileEntity> createProfile(StudentProfileEntity profile) async {
    final model = await _datasource.createProfile(
      StudentProfileModel.fromEntity(profile),
    );
    return model.toEntity();
  }

  @override
  Future<StudentProfileEntity> updateProfile(StudentProfileEntity profile) async {
    final model = await _datasource.updateProfile(
      StudentProfileModel.fromEntity(profile),
    );
    return model.toEntity();
  }

  @override
  Future<String> uploadPhoto(String profileId, Uint8List imageBytes) =>
      _datasource.uploadPhoto(profileId, imageBytes);

  @override
  Stream<StudentProfileEntity?> watchProfileByOwnerId(String ownerId) =>
      _datasource.watchProfileByOwnerId(ownerId).map((model) => model?.toEntity());
}
