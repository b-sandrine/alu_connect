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
    this.founded,
    this.startupStage = '',
    this.companySize = '',
    this.mission = '',
    this.vision = '',
    this.culture = '',
    this.founders = const [],
    this.teamMembers = const [],
    this.galleryImages = const [],
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
  final int? founded;
  final String startupStage;
  final String companySize;
  final String mission;
  final String vision;
  final String culture;
  final List<FounderEntity> founders;
  final List<TeamMemberEntity> teamMembers;
  final List<GalleryImageEntity> galleryImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  static FounderEntity _founderFromMap(Map<String, dynamic> m) {
    return FounderEntity(
      id: m['id'] as String,
      name: m['name'] as String,
      role: m['role'] as String,
      photoUrl: m['photoUrl'] as String?,
      linkedinUrl: m['linkedinUrl'] as String?,
      email: m['email'] as String?,
    );
  }

  static Map<String, dynamic> _founderToMap(FounderEntity f) {
    return {
      'id': f.id,
      'name': f.name,
      'role': f.role,
      'photoUrl': f.photoUrl,
      'linkedinUrl': f.linkedinUrl,
      'email': f.email,
    };
  }

  static TeamMemberEntity _teamMemberFromMap(Map<String, dynamic> m) {
    return TeamMemberEntity(
      id: m['id'] as String,
      name: m['name'] as String,
      role: m['role'] as String,
      department: m['department'] as String,
      photoUrl: m['photoUrl'] as String?,
    );
  }

  static Map<String, dynamic> _teamMemberToMap(TeamMemberEntity m) {
    return {
      'id': m.id,
      'name': m.name,
      'role': m.role,
      'department': m.department,
      'photoUrl': m.photoUrl,
    };
  }

  static GalleryImageEntity _galleryImageFromMap(Map<String, dynamic> m) {
    return GalleryImageEntity(
      id: m['id'] as String,
      url: m['url'] as String,
      category: GalleryCategory.values.byName(m['category'] as String),
      uploadedAt: (m['uploadedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> _galleryImageToMap(GalleryImageEntity g) {
    return {
      'id': g.id,
      'url': g.url,
      'category': g.category.name,
      'uploadedAt': Timestamp.fromDate(g.uploadedAt),
    };
  }

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
      founded: data['founded'] as int?,
      startupStage: data['startupStage'] as String? ?? '',
      companySize: data['companySize'] as String? ?? '',
      mission: data['mission'] as String? ?? '',
      vision: data['vision'] as String? ?? '',
      culture: data['culture'] as String? ?? '',
      founders: (data['founders'] as List<dynamic>? ?? [])
          .map((m) => _founderFromMap(m as Map<String, dynamic>))
          .toList(),
      teamMembers: (data['teamMembers'] as List<dynamic>? ?? [])
          .map((m) => _teamMemberFromMap(m as Map<String, dynamic>))
          .toList(),
      galleryImages: (data['galleryImages'] as List<dynamic>? ?? [])
          .map((m) => _galleryImageFromMap(m as Map<String, dynamic>))
          .toList(),
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
      founded: e.founded,
      startupStage: e.startupStage,
      companySize: e.companySize,
      mission: e.mission,
      vision: e.vision,
      culture: e.culture,
      founders: e.founders,
      teamMembers: e.teamMembers,
      galleryImages: e.galleryImages,
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
      'founded': founded,
      'startupStage': startupStage,
      'companySize': companySize,
      'mission': mission,
      'vision': vision,
      'culture': culture,
      'founders': founders.map(_founderToMap).toList(),
      'teamMembers': teamMembers.map(_teamMemberToMap).toList(),
      'galleryImages': galleryImages.map(_galleryImageToMap).toList(),
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
      founded: founded,
      startupStage: startupStage,
      companySize: companySize,
      mission: mission,
      vision: vision,
      culture: culture,
      founders: founders,
      teamMembers: teamMembers,
      galleryImages: galleryImages,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
