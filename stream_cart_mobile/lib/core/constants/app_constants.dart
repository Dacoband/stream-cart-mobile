class AppConstants {
  // App Info
  static const String appName = 'Stream Cart Mobile';
  static const String appJoinName = 'App';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Stream Cart Mobile-UI is a comprehensive microservices-based e-commerce platform designed for live streaming commerce.';
  
  // Storage Keys
  static const String isFirstTimeKey = 'is_first_time';
  static const String userIdKey = 'user_id';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  
  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double buttonHeight = 48.0;
  
  // Network
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
  static const int sendTimeout = 30; // seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Animation
  static const int animationDuration = 300; // milliseconds
  static const int splashDuration = 2000; // milliseconds
  
  // Date formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  
  // File upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // Error messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String unauthorizedErrorMessage = 'You are not authorized to perform this action.';
  static const String notFoundErrorMessage = 'The requested resource was not found.';
  
  // Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String signupSuccessMessage = 'Account created successfully!';
  static const String logoutSuccessMessage = 'Logged out successfully!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  
  // Social login
  static const String googleClientId = ''; // To be filled with actual Google Client ID
  static const String facebookAppId = ''; // To be filled with actual Facebook App ID
  
  // Deep linking
  static const String appScheme = 'streamcart';
  static const String dynamicLinkDomain = 'streamcart.page.link';
  
  // Feature flags
  static const bool enableGoogleLogin = true;
  static const bool enableFacebookLogin = true;
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
}
