import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/student_profile_entity.dart';

class StudentProfileModel {
  const StudentProfileModel({
    required this.id,
    required this.ownerId,
    this.photoUrl,
    required this.university,
    required this.degree,
    required this.yearOfStudy,
    required this.location,
    required this.bio,
    this.careerInterests = '',
    this.personalStatement = '',
    this.skills = const [],
    this.resumeUrl,
    this.resumeFileName,
    this.resumeUploadedAt,
    this.portfolioUrl,
    this.githubUrl,
    this.linkedinUrl,
    this.behanceUrl,
    this.dribbbleUrl,
    this.mediumUrl,
    this.personalWebsiteUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String? photoUrl;
  final String university;
  final String degree;
  final String yearOfStudy;
  final String location;
  final String bio;
  final String careerInterests;
  final String personalStatement;
  final List<String> skills;
  final String? resumeUrl;
  final String? resumeFileName;
  final DateTime? resumeUploadedAt;
  final String? portfolioUrl;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? behanceUrl;
  final String? dribbbleUrl;
  final String? mediumUrl;
  final String? personalWebsiteUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory StudentProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentProfileModel(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      photoUrl: data['photoUrl'] as String?,
      university: data['university'] as String,
      degree: data['degree'] as String,
      yearOfStudy: data['yearOfStudy'] as String,
      location: data['location'] as String,
      bio: data['bio'] as String,
      careerInterests: data['careerInterests'] as String? ?? '',
      personalStatement: data['personalStatement'] as String? ?? '',
      skills: List<String>.from(data['skills'] as List? ?? []),
      resumeUrl: data['resumeUrl'] as String?,
      resumeFileName: data['resumeFileName'] as String?,
      resumeUploadedAt: (data['resumeUploadedAt'] as Timestamp?)?.toDate(),
      portfolioUrl: data['portfolioUrl'] as String?,
      githubUrl: data['githubUrl'] as String?,
      linkedinUrl: data['linkedinUrl'] as String?,
      behanceUrl: data['behanceUrl'] as String?,
      dribbbleUrl: data['dribbbleUrl'] as String?,
      mediumUrl: data['mediumUrl'] as String?,
      personalWebsiteUrl: data['personalWebsiteUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory StudentProfileModel.fromEntity(StudentProfileEntity e) {
    return StudentProfileModel(
      id: e.id,
      ownerId: e.ownerId,
      photoUrl: e.photoUrl,
      university: e.university,
      degree: e.degree,
      yearOfStudy: e.yearOfStudy,
      location: e.location,
      bio: e.bio,
      careerInterests: e.careerInterests,
      personalStatement: e.personalStatement,
      skills: e.skills,
      resumeUrl: e.resumeUrl,
      resumeFileName: e.resumeFileName,
      resumeUploadedAt: e.resumeUploadedAt,
      portfolioUrl: e.portfolioUrl,
      githubUrl: e.githubUrl,
      linkedinUrl: e.linkedinUrl,
      behanceUrl: e.behanceUrl,
      dribbbleUrl: e.dribbbleUrl,
      mediumUrl: e.mediumUrl,
      personalWebsiteUrl: e.personalWebsiteUrl,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'photoUrl': photoUrl,
      'university': university,
      'degree': degree,
      'yearOfStudy': yearOfStudy,
      'location': location,
      'bio': bio,
      'careerInterests': careerInterests,
      'personalStatement': personalStatement,
      'skills': skills,
      'resumeUrl': resumeUrl,
      'resumeFileName': resumeFileName,
      'resumeUploadedAt':
          resumeUploadedAt != null ? Timestamp.fromDate(resumeUploadedAt!) : null,
      'portfolioUrl': portfolioUrl,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
      'behanceUrl': behanceUrl,
      'dribbbleUrl': dribbbleUrl,
      'mediumUrl': mediumUrl,
      'personalWebsiteUrl': personalWebsiteUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  StudentProfileEntity toEntity() {
    return StudentProfileEntity(
      id: id,
      ownerId: ownerId,
      photoUrl: photoUrl,
      university: university,
      degree: degree,
      yearOfStudy: yearOfStudy,
      location: location,
      bio: bio,
      careerInterests: careerInterests,
      personalStatement: personalStatement,
      skills: skills,
      resumeUrl: resumeUrl,
      resumeFileName: resumeFileName,
      resumeUploadedAt: resumeUploadedAt,
      portfolioUrl: portfolioUrl,
      githubUrl: githubUrl,
      linkedinUrl: linkedinUrl,
      behanceUrl: behanceUrl,
      dribbbleUrl: dribbbleUrl,
      mediumUrl: mediumUrl,
      personalWebsiteUrl: personalWebsiteUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
