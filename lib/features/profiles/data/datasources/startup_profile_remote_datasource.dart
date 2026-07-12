import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../../../../core/utils/storage_upload_helper.dart';
import '../models/startup_profile_model.dart';

class StartupProfileRemoteDatasource {
  StartupProfileRemoteDatasource({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.startupProfilesCollection);

  Future<StartupProfileModel?> getProfileByOwnerId(String ownerId) async {
    try {
      final query = await _collection
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();
      if (query.docs.isEmpty) return null;
      return StartupProfileModel.fromFirestore(query.docs.first);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<StartupProfileModel> getProfileById(String profileId) async {
    try {
      final doc = await _collection.doc(profileId).get();
      if (!doc.exists) throw const NotFoundException('Startup profile not found.');
      return StartupProfileModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<StartupProfileModel> createProfile(StartupProfileModel profile) async {
    try {
      final docRef = _collection.doc();
      final withId = StartupProfileModel(
        id: docRef.id,
        ownerId: profile.ownerId,
        companyName: profile.companyName,
        tagline: profile.tagline,
        description: profile.description,
        industry: profile.industry,
        location: profile.location,
        website: profile.website,
        logoUrl: profile.logoUrl,
        isVerified: profile.isVerified,
        founded: profile.founded,
        startupStage: profile.startupStage,
        companySize: profile.companySize,
        mission: profile.mission,
        vision: profile.vision,
        culture: profile.culture,
        founders: profile.founders,
        teamMembers: profile.teamMembers,
        galleryImages: profile.galleryImages,
        createdAt: profile.createdAt,
        updatedAt: profile.updatedAt,
      );
      await docRef.set(withId.toFirestore());
      return withId;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<StartupProfileModel> updateProfile(StartupProfileModel profile) async {
    try {
      await _collection.doc(profile.id).update(profile.toFirestore());
      return profile;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<String> uploadLogo(String profileId, Uint8List imageBytes) async {
    final downloadUrl = await uploadBytesWithTimeout(
      ref: _storage.ref().child('${AppConstants.startupLogosPath}/$profileId.jpg'),
      bytes: imageBytes,
      contentType: 'image/jpeg',
      label: 'startup-logo:$profileId',
    );
    await _updateProfileField(profileId, 'logoUrl', downloadUrl, label: 'startup-logo:$profileId');
    return downloadUrl;
  }

  /// Uploads a founder's photo and returns its download URL. Callers embed
  /// the URL into the `FounderEntity` before writing the founders array via
  /// [updateProfile] — no separate Firestore write happens here.
  Future<String> uploadFounderPhoto(
    String profileId,
    String founderId,
    Uint8List imageBytes,
  ) {
    return uploadBytesWithTimeout(
      ref: _storage
          .ref()
          .child('${AppConstants.founderPhotosPath}/$profileId/$founderId.jpg'),
      bytes: imageBytes,
      contentType: 'image/jpeg',
      label: 'founder-photo:$profileId/$founderId',
    );
  }

  Future<String> uploadTeamMemberPhoto(
    String profileId,
    String memberId,
    Uint8List imageBytes,
  ) {
    return uploadBytesWithTimeout(
      ref: _storage
          .ref()
          .child('${AppConstants.teamPhotosPath}/$profileId/$memberId.jpg'),
      bytes: imageBytes,
      contentType: 'image/jpeg',
      label: 'team-photo:$profileId/$memberId',
    );
  }

  Future<String> uploadGalleryImage(
    String profileId,
    String imageId,
    Uint8List imageBytes,
  ) {
    return uploadBytesWithTimeout(
      ref: _storage
          .ref()
          .child('${AppConstants.startupGalleryPath}/$profileId/$imageId.jpg'),
      bytes: imageBytes,
      contentType: 'image/jpeg',
      label: 'gallery-image:$profileId/$imageId',
    );
  }

  Future<void> _updateProfileField(
    String profileId,
    String field,
    String value, {
    required String label,
  }) async {
    if (kDebugMode) debugPrint('[StorageUpload] [$label] Firestore update started');
    try {
      await _collection.doc(profileId).update({field: value});
      if (kDebugMode) debugPrint('[StorageUpload] [$label] Firestore update completed');
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Stream<StartupProfileModel?> watchProfileByOwnerId(String ownerId) {
    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .limit(1)
        .snapshots()
        .map((snap) =>
            snap.docs.isEmpty ? null : StartupProfileModel.fromFirestore(snap.docs.first));
  }
}
