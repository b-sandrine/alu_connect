import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchUserDocument(firebaseUser.uid);
    });
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fetchUserDocument(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    } catch (_) {
      throw const NetworkException('Sign in failed. Please try again.');
    }
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);

      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        role: role,
        hasCompletedOnboarding: false,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toFirestore());

      return user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    } catch (_) {
      throw const NetworkException('Registration failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw const AuthException('Sign out failed. Please try again.');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _fetchUserDocument(firebaseUser.uid);
  }

  Future<void> completeOnboarding(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'hasCompletedOnboarding': true});
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> updateFcmToken(String userId, String token) async {
    try {
      await _firestore.collection(AppConstants.usersCollection).doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> clearFcmToken(String userId) async {
    try {
      await _firestore.collection(AppConstants.usersCollection).doc(userId).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> updateLastActiveAt(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'lastActiveAt': Timestamp.now()});
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Stream<UserModel?> watchUserById(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    }
  }

  Future<void> _reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthException('You must be signed in to do this.');
    }
    try {
      final credential =
          EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _reauthenticate(currentPassword);
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    }
  }

  Future<void> deleteAccount({required String password}) async {
    await _reauthenticate(password);
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final uid = user.uid;
      final batch = _firestore.batch();

      final studentProfiles = await _firestore
          .collection(AppConstants.studentProfilesCollection)
          .where('ownerId', isEqualTo: uid)
          .get();
      for (final doc in studentProfiles.docs) {
        batch.delete(doc.reference);
      }

      final startupProfiles = await _firestore
          .collection(AppConstants.startupProfilesCollection)
          .where('ownerId', isEqualTo: uid)
          .get();
      for (final doc in startupProfiles.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(_firestore.collection(AppConstants.usersCollection).doc(uid));
      await batch.commit();

      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<UserModel> _fetchUserDocument(String uid) async {
    try {
      final collection = _firestore.collection(AppConstants.usersCollection);
      var doc = await collection.doc(uid).get();

      // Right after account creation, Firebase's authStateChanges() can
      // notify listeners a moment before the corresponding profile document
      // finishes writing (see createUserWithEmailAndPassword below). Retry
      // briefly instead of surfacing a hard "not found" error that would
      // permanently poison the authStateChanges stream.
      var attempts = 0;
      while (!doc.exists && attempts < 5) {
        await Future.delayed(const Duration(milliseconds: 300));
        doc = await collection.doc(uid).get();
        attempts++;
      }

      if (!doc.exists) throw const NotFoundException('User profile not found.');
      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }
}
