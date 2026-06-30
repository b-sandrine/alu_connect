import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/opportunity_entity.dart';

class OpportunityModel extends OpportunityEntity {
  const OpportunityModel({
    required super.id,
    required super.startupId,
    required super.startupName,
    super.startupLogoUrl,
    required super.title,
    required super.description,
    required super.type,
    required super.category,
    required super.requiredSkills,
    required super.location,
    super.isRemote,
    required super.deadline,
    super.compensation,
    required super.createdAt,
    required super.updatedAt,
    super.isActive,
  });

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
    };
  }
}
