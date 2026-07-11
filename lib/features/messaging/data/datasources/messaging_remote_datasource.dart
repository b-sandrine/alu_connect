import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/firebase_error_mapper.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class MessagingRemoteDatasource {
  MessagingRemoteDatasource({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _firestore.collection(AppConstants.conversationsCollection);

  CollectionReference<Map<String, dynamic>> _messages(String conversationId) =>
      _conversations.doc(conversationId).collection(AppConstants.messagesSubcollection);

  /// Deterministic doc ID for a 1:1 conversation — avoids needing a query to
  /// find an existing thread between two users (direct doc read instead).
  static String conversationIdFor(String userIdA, String userIdB) {
    final ids = [userIdA, userIdB]..sort();
    return ids.join('_');
  }

  Stream<List<ConversationModel>> watchConversations(String userId) {
    return _conversations
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ConversationModel.fromFirestore).toList());
  }

  Stream<ConversationModel?> watchConversation(String conversationId) {
    return _conversations
        .doc(conversationId)
        .snapshots()
        .map((doc) => doc.exists ? ConversationModel.fromFirestore(doc) : null);
  }

  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return _messages(conversationId)
        .orderBy('sentAt')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MessageModel.fromFirestore(doc, conversationId))
            .toList());
  }

  Future<ConversationModel> getOrCreateConversation({
    required String currentUserId,
    required String currentUserName,
    String? currentUserPhotoUrl,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhotoUrl,
    String? contextOpportunityId,
    String? contextOpportunityTitle,
  }) async {
    try {
      final id = conversationIdFor(currentUserId, otherUserId);
      final docRef = _conversations.doc(id);
      final existing = await docRef.get();
      if (existing.exists) {
        return ConversationModel.fromFirestore(existing);
      }

      final model = ConversationModel(
        id: id,
        participantIds: [currentUserId, otherUserId],
        participantNames: {
          currentUserId: currentUserName,
          otherUserId: otherUserName,
        },
        participantPhotoUrls: {
          currentUserId: currentUserPhotoUrl,
          otherUserId: otherUserPhotoUrl,
        },
        contextOpportunityId: contextOpportunityId,
        contextOpportunityTitle: contextOpportunityTitle,
        createdAt: DateTime.now(),
      );
      await docRef.set(model.toFirestore());
      return model;
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    try {
      final now = DateTime.now();
      final messageRef = _messages(conversationId).doc();
      final batch = _firestore.batch();
      batch.set(
        messageRef,
        MessageModel(
          id: messageRef.id,
          conversationId: conversationId,
          senderId: senderId,
          text: text,
          sentAt: now,
        ).toFirestore(),
      );
      batch.update(_conversations.doc(conversationId), {
        'lastMessageText': text,
        'lastMessageSenderId': senderId,
        'lastMessageAt': Timestamp.fromDate(now),
        'typingUserIds': FieldValue.arrayRemove([senderId]),
      });
      await batch.commit();
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required File imageFile,
  }) async {
    final messageRef = _messages(conversationId).doc();
    String imageUrl;
    try {
      final ref = _storage
          .ref()
          .child('${AppConstants.chatImagesPath}/$conversationId/${messageRef.id}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageException('Image upload failed: ${e.message}');
    }

    try {
      final now = DateTime.now();
      final batch = _firestore.batch();
      batch.set(
        messageRef,
        MessageModel(
          id: messageRef.id,
          conversationId: conversationId,
          senderId: senderId,
          imageUrl: imageUrl,
          sentAt: now,
        ).toFirestore(),
      );
      batch.update(_conversations.doc(conversationId), {
        'lastMessageText': '📷 Photo',
        'lastMessageSenderId': senderId,
        'lastMessageAt': Timestamp.fromDate(now),
        'typingUserIds': FieldValue.arrayRemove([senderId]),
      });
      await batch.commit();
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> setTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) async {
    try {
      await _conversations.doc(conversationId).update({
        'typingUserIds': isTyping
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
        'typingUpdatedAt.$userId': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _conversations.doc(conversationId).update({
        'lastReadAt.$userId': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseErrorMapper.fromCode(e.code);
    }
  }
}
