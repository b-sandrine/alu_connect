import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.sentAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final DateTime sentAt;

  factory MessageModel.fromFirestore(DocumentSnapshot doc, String conversationId) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      conversationId: conversationId,
      senderId: data['senderId'] as String,
      text: data['text'] as String?,
      imageUrl: data['imageUrl'] as String?,
      sentAt: (data['sentAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'sentAt': Timestamp.fromDate(sentAt),
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      imageUrl: imageUrl,
      sentAt: sentAt,
    );
  }
}
