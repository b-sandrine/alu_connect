class AppConstants {
  AppConstants._();

  static const String appName = 'ALU Connect';
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String startupProfilesCollection = 'startup_profiles';
  static const String opportunitiesCollection = 'opportunities';
  static const String applicationsCollection = 'applications';
  static const String bookmarksCollection = 'bookmarks';

  // Storage paths
  static const String profileImagesPath = 'profile_images';
  static const String startupLogosPath = 'startup_logos';

  // Pagination
  static const int opportunitiesPageSize = 20;

  // Animation durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);
}
