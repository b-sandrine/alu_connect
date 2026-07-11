import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

@freezed
abstract class MessageEntity with _$MessageEntity {
  const MessageEntity._();

  const factory MessageEntity({
    required String id,
    required String conversationId,
    required String senderId,
    String? text,
    String? imageUrl,
    required DateTime sentAt,
  }) = _MessageEntity;

  bool get isImage => imageUrl != null;
}
