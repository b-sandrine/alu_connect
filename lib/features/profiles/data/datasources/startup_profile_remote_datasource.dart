import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
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

  Future<String> uploadLogo(String profileId, File imageFile) async {
    try {
      final ref = _storage.ref().child(
            '${AppConstants.startupLogosPath}/$profileId.jpg',
          );
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      await _collection.doc(profileId).update({'logoUrl': downloadUrl});
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException('Logo upload failed: ${e.message}');
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
