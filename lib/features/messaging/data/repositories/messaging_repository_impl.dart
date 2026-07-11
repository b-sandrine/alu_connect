import 'dart:typed_data';

import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../datasources/messaging_remote_datasource.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  const MessagingRepositoryImpl(this._datasource);

  final MessagingRemoteDatasource _datasource;

  @override
  Stream<List<ConversationEntity>> watchConversations(String userId) =>
      _datasource
          .watchConversations(userId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<ConversationEntity?> watchConversation(String conversationId) =>
      _datasource
          .watchConversation(conversationId)
          .map((model) => model?.toEntity());

  @override
  Stream<List<MessageEntity>> watchMessages(String conversationId) =>
      _datasource
          .watchMessages(conversationId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Future<ConversationEntity> getOrCreateConversation({
    required String currentUserId,
    required String currentUserName,
    String? currentUserPhotoUrl,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhotoUrl,
    String? contextOpportunityId,
    String? contextOpportunityTitle,
  }) async {
    final model = await _datasource.getOrCreateConversation(
      currentUserId: currentUserId,
      currentUserName: currentUserName,
      currentUserPhotoUrl: currentUserPhotoUrl,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserPhotoUrl: otherUserPhotoUrl,
      contextOpportunityId: contextOpportunityId,
      contextOpportunityTitle: contextOpportunityTitle,
    );
    return model.toEntity();
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) =>
      _datasource.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        text: text,
      );

  @override
  Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required Uint8List imageBytes,
  }) =>
      _datasource.sendImageMessage(
        conversationId: conversationId,
        senderId: senderId,
        imageBytes: imageBytes,
      );

  @override
  Future<void> setTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) =>
      _datasource.setTyping(
        conversationId: conversationId,
        userId: userId,
        isTyping: isTyping,
      );

  @override
  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) =>
      _datasource.markAsRead(conversationId: conversationId, userId: userId);
}
