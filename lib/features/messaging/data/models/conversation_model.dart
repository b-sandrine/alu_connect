import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/conversation_entity.dart';

Map<String, DateTime> _timestampMapToDateTime(Map<String, dynamic>? raw) {
  if (raw == null) return {};
  return raw.map((key, value) => MapEntry(key, (value as Timestamp).toDate()));
}

Map<String, Timestamp> _dateTimeMapToTimestamp(Map<String, DateTime> map) {
  return map.map((key, value) => MapEntry(key, Timestamp.fromDate(value)));
}

class ConversationModel {
  const ConversationModel({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    this.participantPhotoUrls = const {},
    this.contextOpportunityId,
    this.contextOpportunityTitle,
    this.lastMessageText,
    this.lastMessageSenderId,
    this.lastMessageAt,
    this.lastReadAt = const {},
    this.typingUserIds = const [],
    this.typingUpdatedAt = const {},
    required this.createdAt,
  });

  final String id;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final Map<String, String?> participantPhotoUrls;
  final String? contextOpportunityId;
  final String? contextOpportunityTitle;
  final String? lastMessageText;
  final String? lastMessageSenderId;
  final DateTime? lastMessageAt;
  final Map<String, DateTime> lastReadAt;
  final List<String> typingUserIds;
  final Map<String, DateTime> typingUpdatedAt;
  final DateTime createdAt;

  factory ConversationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversationModel(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] as List),
      participantNames:
          Map<String, String>.from(data['participantNames'] as Map),
      participantPhotoUrls: Map<String, String?>.from(
          data['participantPhotoUrls'] as Map? ?? {}),
      contextOpportunityId: data['contextOpportunityId'] as String?,
      contextOpportunityTitle: data['contextOpportunityTitle'] as String?,
      lastMessageText: data['lastMessageText'] as String?,
      lastMessageSenderId: data['lastMessageSenderId'] as String?,
      lastMessageAt: data['lastMessageAt'] != null
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : null,
      lastReadAt: _timestampMapToDateTime(
          (data['lastReadAt'] as Map?)?.cast<String, dynamic>()),
      typingUserIds: List<String>.from(data['typingUserIds'] as List? ?? []),
      typingUpdatedAt: _timestampMapToDateTime(
          (data['typingUpdatedAt'] as Map?)?.cast<String, dynamic>()),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participantIds': participantIds,
      'participantNames': participantNames,
      'participantPhotoUrls': participantPhotoUrls,
      'contextOpportunityId': contextOpportunityId,
      'contextOpportunityTitle': contextOpportunityTitle,
      'lastMessageText': lastMessageText,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageAt':
          lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
      'lastReadAt': _dateTimeMapToTimestamp(lastReadAt),
      'typingUserIds': typingUserIds,
      'typingUpdatedAt': _dateTimeMapToTimestamp(typingUpdatedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      participantIds: participantIds,
      participantNames: participantNames,
      participantPhotoUrls: participantPhotoUrls,
      contextOpportunityId: contextOpportunityId,
      contextOpportunityTitle: contextOpportunityTitle,
      lastMessageText: lastMessageText,
      lastMessageSenderId: lastMessageSenderId,
      lastMessageAt: lastMessageAt,
      lastReadAt: lastReadAt,
      typingUserIds: typingUserIds,
      typingUpdatedAt: typingUpdatedAt,
      createdAt: createdAt,
    );
  }
}
