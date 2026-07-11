import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_entity.freezed.dart';

@freezed
abstract class ConversationEntity with _$ConversationEntity {
  const ConversationEntity._();

  const factory ConversationEntity({
    required String id,
    required List<String> participantIds,
    required Map<String, String> participantNames,
    @Default(<String, String?>{}) Map<String, String?> participantPhotoUrls,
    String? contextOpportunityId,
    String? contextOpportunityTitle,
    String? lastMessageText,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    @Default(<String, DateTime>{}) Map<String, DateTime> lastReadAt,
    @Default(<String>[]) List<String> typingUserIds,
    @Default(<String, DateTime>{}) Map<String, DateTime> typingUpdatedAt,
    required DateTime createdAt,
  }) = _ConversationEntity;

  static const _typingStaleness = Duration(seconds: 5);

  String otherParticipantId(String myUserId) =>
      participantIds.firstWhere((id) => id != myUserId, orElse: () => '');

  String otherParticipantName(String myUserId) =>
      participantNames[otherParticipantId(myUserId)] ?? 'Unknown';

  String? otherParticipantPhotoUrl(String myUserId) =>
      participantPhotoUrls[otherParticipantId(myUserId)];

  bool hasUnread(String myUserId) {
    final lastMessage = lastMessageAt;
    if (lastMessage == null) return false;
    final readAt = lastReadAt[myUserId];
    if (readAt == null) return true;
    return lastMessage.isAfter(readAt);
  }

  /// A message the current user sent is "read" once the other participant's
  /// lastReadAt passes its sentAt — no per-message read tracking needed.
  bool isReadByOther(String myUserId, DateTime messageSentAt) {
    final otherId = otherParticipantId(myUserId);
    final otherReadAt = lastReadAt[otherId];
    if (otherReadAt == null) return false;
    return !otherReadAt.isBefore(messageSentAt);
  }

  bool isOtherTyping(String myUserId) {
    final otherId = otherParticipantId(myUserId);
    if (!typingUserIds.contains(otherId)) return false;
    final updatedAt = typingUpdatedAt[otherId];
    if (updatedAt == null) return false;
    return DateTime.now().difference(updatedAt) < _typingStaleness;
  }
}
