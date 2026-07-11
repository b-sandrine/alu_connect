import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/opportunity_entity.dart';

class OpportunityModel {
  const OpportunityModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    this.startupLogoUrl,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.requiredSkills,
    required this.location,
    this.isRemote = false,
    required this.deadline,
    this.compensation,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.viewCount = 0,
  });

  final String id;
  final String startupId;
  final String startupName;
  final String? startupLogoUrl;
  final String title;
  final String description;
  final OpportunityType type;
  final OpportunityCategory category;
  final List<String> requiredSkills;
  final String location;
  final bool isRemote;
  final DateTime deadline;
  final String? compensation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int viewCount;

  factory OpportunityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OpportunityModel(
      id: doc.id,
      startupId: data['startupId'] as String,
      startupName: data['startupName'] as String,
      startupLogoUrl: data['startupLogoUrl'] as String?,
      title: data['title'] as String,
      description: data['description'] as String,
      type: OpportunityType.values.byName(data['type'] as String),
      category: OpportunityCategory.values.byName(data['category'] as String),
      requiredSkills: List<String>.from(data['requiredSkills'] as List),
      location: data['location'] as String,
      isRemote: data['isRemote'] as bool? ?? false,
      deadline: (data['deadline'] as Timestamp).toDate(),
      compensation: data['compensation'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] as bool? ?? true,
      viewCount: (data['viewCount'] as num?)?.toInt() ?? 0,
    );
  }

  factory OpportunityModel.fromEntity(OpportunityEntity e) {
    return OpportunityModel(
      id: e.id,
      startupId: e.startupId,
      startupName: e.startupName,
      startupLogoUrl: e.startupLogoUrl,
      title: e.title,
      description: e.description,
      type: e.type,
      category: e.category,
      requiredSkills: e.requiredSkills,
      location: e.location,
      isRemote: e.isRemote,
      deadline: e.deadline,
      compensation: e.compensation,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      isActive: e.isActive,
      viewCount: e.viewCount,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'startupLogoUrl': startupLogoUrl,
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.name,
      'requiredSkills': requiredSkills,
      'location': location,
      'isRemote': isRemote,
      'deadline': Timestamp.fromDate(deadline),
      'compensation': compensation,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'viewCount': viewCount,
    };
  }

  OpportunityEntity toEntity() {
    return OpportunityEntity(
      id: id,
      startupId: startupId,
      startupName: startupName,
      startupLogoUrl: startupLogoUrl,
      title: title,
      description: description,
      type: type,
      category: category,
      requiredSkills: requiredSkills,
      location: location,
      isRemote: isRemote,
      deadline: deadline,
      compensation: compensation,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}
