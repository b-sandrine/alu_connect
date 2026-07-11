import 'dart:typed_data';
import '../entities/startup_profile_entity.dart';

abstract interface class StartupProfileRepository {
  Future<StartupProfileEntity?> getProfileByOwnerId(String ownerId);

  Future<StartupProfileEntity> getProfileById(String profileId);

  Future<StartupProfileEntity> createProfile(StartupProfileEntity profile);

  Future<StartupProfileEntity> updateProfile(StartupProfileEntity profile);

  Future<String> uploadLogo(String profileId, Uint8List imageBytes);

  Future<String> uploadFounderPhoto(
    String profileId,
    String founderId,
    Uint8List imageBytes,
  );

  Future<String> uploadTeamMemberPhoto(
    String profileId,
    String memberId,
    Uint8List imageBytes,
  );

  Future<String> uploadGalleryImage(
    String profileId,
    String imageId,
    Uint8List imageBytes,
  );

  Stream<StartupProfileEntity?> watchProfileByOwnerId(String ownerId);
}
