import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/startup_profile_entity.dart';

class StartupProfileModel extends StartupProfileEntity {
  const StartupProfileModel({
    required super.id,
    required super.ownerId,
    required super.companyName,
    required super.tagline,
    required super.description,
    required super.industry,
    required super.location,
    super.website,
    super.logoUrl,
    super.isVerified,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StartupProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StartupProfileModel(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      companyName: data['companyName'] as String,
      tagline: data['tagline'] as String,
      description: data['description'] as String,
      industry: data['industry'] as String,
      location: data['location'] as String,
      website: data['website'] as String?,
      logoUrl: data['logoUrl'] as String?,
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'companyName': companyName,
      'tagline': tagline,
      'description': description,
      'industry': industry,
      'location': location,
      'website': website,
      'logoUrl': logoUrl,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  StartupProfileModel copyWith({
    String? companyName,
    String? tagline,
    String? description,
    String? industry,
    String? location,
    String? website,
    String? logoUrl,
    bool? isVerified,
  }) {
    return StartupProfileModel(
      id: id,
      ownerId: ownerId,
      companyName: companyName ?? this.companyName,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      website: website ?? this.website,
      logoUrl: logoUrl ?? this.logoUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
