import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/datasources/messaging_remote_datasource.dart';
import '../../data/repositories/messaging_repository_impl.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';

final messagingRemoteDatasourceProvider =
    Provider<MessagingRemoteDatasource>((ref) {
  return MessagingRemoteDatasource(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.watch(messagingRemoteDatasourceProvider));
});

final conversationsProvider =
    StreamProvider.family<List<ConversationEntity>, String>((ref, userId) {
  return ref.watch(messagingRepositoryProvider).watchConversations(userId);
});

final conversationProvider =
    StreamProvider.family<ConversationEntity?, String>((ref, conversationId) {
  return ref.watch(messagingRepositoryProvider).watchConversation(conversationId);
});

final messagesProvider =
    StreamProvider.family<List<MessageEntity>, String>((ref, conversationId) {
  return ref.watch(messagingRepositoryProvider).watchMessages(conversationId);
});

/// Number of conversations with an unread message — for the nav badge.
final unreadConversationCountProvider =
    Provider.family<int, String>((ref, userId) {
  final conversationsAsync = ref.watch(conversationsProvider(userId));
  return conversationsAsync.valueOrNull
          ?.where((c) => c.hasUnread(userId))
          .length ??
      0;
});

class MessagingController extends AsyncNotifier<void> {
  late MessagingRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.watch(messagingRepositoryProvider);
  }

  Future<ConversationEntity?> startConversation({
    required String currentUserId,
    required String currentUserName,
    String? currentUserPhotoUrl,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhotoUrl,
    String? contextOpportunityId,
    String? contextOpportunityTitle,
  }) async {
    state = const AsyncLoading();
    ConversationEntity? conversation;
    state = await AsyncValue.guard(() async {
      conversation = await _repository.getOrCreateConversation(
        currentUserId: currentUserId,
        currentUserName: currentUserName,
        currentUserPhotoUrl: currentUserPhotoUrl,
        otherUserId: otherUserId,
        otherUserName: otherUserName,
        otherUserPhotoUrl: otherUserPhotoUrl,
        contextOpportunityId: contextOpportunityId,
        contextOpportunityTitle: contextOpportunityTitle,
      );
    });
    return conversation;
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    state = await AsyncValue.guard(
      () => _repository.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        text: text,
      ),
    );
  }

  Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required Uint8List imageBytes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.sendImageMessage(
        conversationId: conversationId,
        senderId: senderId,
        imageBytes: imageBytes,
      ),
    );
  }

  Future<void> setTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) {
    return _repository.setTyping(
      conversationId: conversationId,
      userId: userId,
      isTyping: isTyping,
    );
  }

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) {
    return _repository.markAsRead(conversationId: conversationId, userId: userId);
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }
}

final messagingControllerProvider =
    AsyncNotifierProvider<MessagingController, void>(MessagingController.new);
