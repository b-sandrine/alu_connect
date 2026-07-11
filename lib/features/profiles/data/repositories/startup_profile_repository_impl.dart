import 'dart:typed_data';

import '../../domain/entities/startup_profile_entity.dart';
import '../../domain/repositories/startup_profile_repository.dart';
import '../datasources/startup_profile_remote_datasource.dart';
import '../models/startup_profile_model.dart';

class StartupProfileRepositoryImpl implements StartupProfileRepository {
  const StartupProfileRepositoryImpl(this._datasource);

  final StartupProfileRemoteDatasource _datasource;

  @override
  Future<StartupProfileEntity?> getProfileByOwnerId(String ownerId) async {
    final model = await _datasource.getProfileByOwnerId(ownerId);
    return model?.toEntity();
  }

  @override
  Future<StartupProfileEntity> getProfileById(String profileId) async {
    final model = await _datasource.getProfileById(profileId);
    return model.toEntity();
  }

  @override
  Future<StartupProfileEntity> createProfile(StartupProfileEntity profile) async {
    final model = await _datasource.createProfile(
      StartupProfileModel.fromEntity(profile),
    );
    return model.toEntity();
  }

  @override
  Future<StartupProfileEntity> updateProfile(StartupProfileEntity profile) async {
    final model = await _datasource.updateProfile(
      StartupProfileModel.fromEntity(profile),
    );
    return model.toEntity();
  }

  @override
  Future<String> uploadLogo(String profileId, Uint8List imageBytes) =>
      _datasource.uploadLogo(profileId, imageBytes);

  @override
  Stream<StartupProfileEntity?> watchProfileByOwnerId(String ownerId) =>
      _datasource.watchProfileByOwnerId(ownerId).map((model) => model?.toEntity());
}
