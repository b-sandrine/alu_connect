class AppConstants {
  AppConstants._();

  static const String appName = 'ALU Connect';
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String startupProfilesCollection = 'startup_profiles';
  static const String studentProfilesCollection = 'student_profiles';
  static const String opportunitiesCollection = 'opportunities';
  static const String applicationsCollection = 'applications';
  static const String bookmarksCollection = 'bookmarks';
  static const String conversationsCollection = 'conversations';
  static const String messagesSubcollection = 'messages';

  // Storage paths
  static const String profileImagesPath = 'profile_images';
  static const String startupLogosPath = 'startup_logos';
  static const String chatImagesPath = 'chat_images';
  static const String founderPhotosPath = 'founder_photos';
  static const String teamPhotosPath = 'team_photos';
  static const String startupGalleryPath = 'startup_gallery';
  static const String resumesPath = 'resumes';
  static const String projectImagesPath = 'project_images';

  // Pagination
  static const int opportunitiesPageSize = 20;

  // Animation durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Messaging / presence
  static const Duration presenceHeartbeatInterval = Duration(seconds: 30);
  static const Duration onlineThreshold = Duration(seconds: 60);
  static const Duration typingStaleness = Duration(seconds: 5);
}
