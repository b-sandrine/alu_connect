import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../models/student_profile_model.dart';

class StudentProfileRemoteDatasource {
  StudentProfileRemoteDatasource({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.studentProfilesCollection);

  Future<StudentProfileModel?> getProfileByOwnerId(String ownerId) async {
    try {
      final query =
          await _collection.where('ownerId', isEqualTo: ownerId).limit(1).get();
      if (query.docs.isEmpty) return null;
      return StudentProfileModel.fromFirestore(query.docs.first);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<StudentProfileModel> createProfile(StudentProfileModel profile) async {
    try {
      final docRef = _collection.doc();
      final withId = StudentProfileModel(
        id: docRef.id,
        ownerId: profile.ownerId,
        photoUrl: profile.photoUrl,
        university: profile.university,
        degree: profile.degree,
        yearOfStudy: profile.yearOfStudy,
        location: profile.location,
        bio: profile.bio,
        careerInterests: profile.careerInterests,
        personalStatement: profile.personalStatement,
        skills: profile.skills,
        createdAt: profile.createdAt,
        updatedAt: profile.updatedAt,
      );
      await docRef.set(withId.toFirestore());
      return withId;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<StudentProfileModel> updateProfile(StudentProfileModel profile) async {
    try {
      await _collection.doc(profile.id).update(profile.toFirestore());
      return profile;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<String> uploadPhoto(String profileId, Uint8List imageBytes) async {
    try {
      final ref = _storage
          .ref()
          .child('${AppConstants.profileImagesPath}/$profileId.jpg');
      await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
      final downloadUrl = await ref.getDownloadURL();
      await _collection.doc(profileId).update({'photoUrl': downloadUrl});
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException('Photo upload failed: ${e.message}');
    }
  }

  Stream<StudentProfileModel?> watchProfileByOwnerId(String ownerId) {
    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isEmpty
            ? null
            : StudentProfileModel.fromFirestore(snap.docs.first));
  }
}
