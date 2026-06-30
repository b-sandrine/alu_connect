import 'dart:io';

import '../../domain/entities/startup_profile_entity.dart';
import '../../domain/repositories/startup_profile_repository.dart';
import '../datasources/startup_profile_remote_datasource.dart';
import '../models/startup_profile_model.dart';

class StartupProfileRepositoryImpl implements StartupProfileRepository {
  const StartupProfileRepositoryImpl(this._datasource);

  final StartupProfileRemoteDatasource _datasource;

  @override
  Future<StartupProfileEntity?> getProfileByOwnerId(String ownerId) =>
      _datasource.getProfileByOwnerId(ownerId);

  @override
  Future<StartupProfileEntity> getProfileById(String profileId) =>
      _datasource.getProfileById(profileId);

  @override
  Future<StartupProfileEntity> createProfile(StartupProfileEntity profile) =>
      _datasource.createProfile(_toModel(profile));

  @override
  Future<StartupProfileEntity> updateProfile(StartupProfileEntity profile) =>
      _datasource.updateProfile(_toModel(profile));

  @override
  Future<String> uploadLogo(String profileId, File imageFile) =>
      _datasource.uploadLogo(profileId, imageFile);

  @override
  Stream<StartupProfileEntity?> watchProfileByOwnerId(String ownerId) =>
      _datasource.watchProfileByOwnerId(ownerId);

  StartupProfileModel _toModel(StartupProfileEntity entity) {
    return StartupProfileModel(
      id: entity.id,
      ownerId: entity.ownerId,
      companyName: entity.companyName,
      tagline: entity.tagline,
      description: entity.description,
      industry: entity.industry,
      location: entity.location,
      website: entity.website,
      logoUrl: entity.logoUrl,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
