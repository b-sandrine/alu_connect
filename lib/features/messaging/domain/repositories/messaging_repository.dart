import 'dart:io';

import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

abstract interface class MessagingRepository {
  Stream<List<ConversationEntity>> watchConversations(String userId);

  Stream<ConversationEntity?> watchConversation(String conversationId);

  Stream<List<MessageEntity>> watchMessages(String conversationId);

  /// Looks up an existing (currentUserId, otherUserId) thread before
  /// creating a new one — a student re-messaging the same startup about a
  /// different opportunity stays in one conversation.
  Future<ConversationEntity> getOrCreateConversation({
    required String currentUserId,
    required String currentUserName,
    String? currentUserPhotoUrl,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhotoUrl,
    String? contextOpportunityId,
    String? contextOpportunityTitle,
  });

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  });

  Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required File imageFile,
  });

  Future<void> setTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  });

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  });
}
