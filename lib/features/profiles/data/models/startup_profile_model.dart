import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/startup_profile_entity.dart';

class StartupProfileModel {
  const StartupProfileModel({
    required this.id,
    required this.ownerId,
    required this.companyName,
    required this.tagline,
    required this.description,
    required this.industry,
    required this.location,
    this.website,
    this.logoUrl,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String companyName;
  final String tagline;
  final String description;
  final String industry;
  final String location;
  final String? website;
  final String? logoUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  factory StartupProfileModel.fromEntity(StartupProfileEntity e) {
    return StartupProfileModel(
      id: e.id,
      ownerId: e.ownerId,
      companyName: e.companyName,
      tagline: e.tagline,
      description: e.description,
      industry: e.industry,
      location: e.location,
      website: e.website,
      logoUrl: e.logoUrl,
      isVerified: e.isVerified,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
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

  StartupProfileEntity toEntity() {
    return StartupProfileEntity(
      id: id,
      ownerId: ownerId,
      companyName: companyName,
      tagline: tagline,
      description: description,
      industry: industry,
      location: location,
      website: website,
      logoUrl: logoUrl,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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
