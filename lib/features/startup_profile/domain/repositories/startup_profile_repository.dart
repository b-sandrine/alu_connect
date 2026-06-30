import 'dart:io';
import '../entities/startup_profile_entity.dart';

abstract interface class StartupProfileRepository {
  Future<StartupProfileEntity?> getProfileByOwnerId(String ownerId);

  Future<StartupProfileEntity> getProfileById(String profileId);

  Future<StartupProfileEntity> createProfile(StartupProfileEntity profile);

  Future<StartupProfileEntity> updateProfile(StartupProfileEntity profile);

  Future<String> uploadLogo(String profileId, File imageFile);

  Stream<StartupProfileEntity?> watchProfileByOwnerId(String ownerId);
}
