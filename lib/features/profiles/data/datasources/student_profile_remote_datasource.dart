import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../../../../core/utils/storage_upload_helper.dart';
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
        resumeUrl: profile.resumeUrl,
        resumeFileName: profile.resumeFileName,
        resumeUploadedAt: profile.resumeUploadedAt,
        portfolioUrl: profile.portfolioUrl,
        githubUrl: profile.githubUrl,
        linkedinUrl: profile.linkedinUrl,
        behanceUrl: profile.behanceUrl,
        dribbbleUrl: profile.dribbbleUrl,
        mediumUrl: profile.mediumUrl,
        personalWebsiteUrl: profile.personalWebsiteUrl,
        projects: profile.projects,
        createdAt: profile.createdAt,
        updatedAt: profile.updatedAt,
      );
      await docRef.set(withId.toFirestore());
      return withId;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  /// Fetches profiles for exactly the given owner UIDs — used by the startup
  /// analytics dashboard to aggregate applicants' skills/locations without a
  /// per-applicant query. Firestore's `whereIn` caps at 30 values, so this
  /// chunks like `OpportunityRemoteDatasource.getOpportunitiesByIds`.
  Future<List<StudentProfileModel>> getProfilesByOwnerIds(
    List<String> ownerIds,
  ) async {
    if (ownerIds.isEmpty) return [];
    try {
      final chunks = <List<String>>[
        for (var i = 0; i < ownerIds.length; i += 30)
          ownerIds.sublist(
            i,
            i + 30 > ownerIds.length ? ownerIds.length : i + 30,
          ),
      ];
      final snapshots = await Future.wait(
        chunks.map(
          (chunk) => _collection.where('ownerId', whereIn: chunk).get(),
        ),
      );
      return snapshots
          .expand((snap) => snap.docs)
          .map(StudentProfileModel.fromFirestore)
          .toList();
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
    final downloadUrl = await uploadBytesWithTimeout(
      ref: _storage.ref().child('${AppConstants.profileImagesPath}/$profileId.jpg'),
      bytes: imageBytes,
      contentType: 'image/jpeg',
      label: 'student-photo:$profileId',
    );
    await _updateProfileFields(
      profileId,
      {'photoUrl': downloadUrl},
      label: 'student-photo:$profileId',
    );
    return downloadUrl;
  }

  Future<String> uploadResume(
    String profileId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    final downloadUrl = await uploadBytesWithTimeout(
      ref: _storage.ref().child('${AppConstants.resumesPath}/$profileId.pdf'),
      bytes: fileBytes,
      contentType: 'application/pdf',
      label: 'resume:$profileId',
    );
    await _updateProfileFields(
      profileId,
      {
        'resumeUrl': downloadUrl,
        'resumeFileName': fileName,
        'resumeUploadedAt': Timestamp.now(),
      },
      label: 'resume:$profileId',
    );
    return downloadUrl;
  }

  /// Uploads one image for a project and returns its download URL. Callers
  /// embed the URL into the project's `imageUrls` list before writing via
  /// [updateProfile] — no separate Firestore write happens here (mirrors
  /// `uploadFounderPhoto` etc. in the startup profile datasource).
  Future<String> uploadProjectImage(
    String profileId,
    String projectId,
    String imageId,
    Uint8List imageBytes,
  ) {
    return uploadBytesWithTimeout(
      ref: _storage.ref().child(
            '${AppConstants.projectImagesPath}/$profileId/$projectId/$imageId.jpg',
          ),
      bytes: imageBytes,
      contentType: 'image/jpeg',
      label: 'project-image:$profileId/$projectId',
    );
  }

  Future<void> _updateProfileFields(
    String profileId,
    Map<String, dynamic> fields, {
    required String label,
  }) async {
    if (kDebugMode) debugPrint('[StorageUpload] [$label] Firestore update started');
    try {
      await _collection.doc(profileId).update(fields);
      if (kDebugMode) debugPrint('[StorageUpload] [$label] Firestore update completed');
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
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
