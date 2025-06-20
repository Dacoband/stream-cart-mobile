import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
  
  // Base API Key (if needed)
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  // Base URL - extracted from the first API URL
  static String get baseUrl => 'https://brightpa.me';
    // Auth API endpoints
  static String get loginUrl => dotenv.env['API_LOGIN_URL'] ?? '';
  static String get refreshTokenUrl => dotenv.env['API_REFRESH_TOKEN'] ?? '';
  static String get registerUrl => dotenv.env['API_REGISTER_URL'] ?? '';
  static String get verifyAccountUrl => dotenv.env['API_VERIFY_ACCOUNT'] ?? '';
  static String get resetPasswordRequestUrl => dotenv.env['API_RESET_PASSWORD_REQUEST'] ?? '';
  static String get resetPasswordUrl => dotenv.env['API_RESET_PASSWORD'] ?? '';
  static String get changePasswordUrl => dotenv.env['API_CHANGE_PASSWORD'] ?? '';
  static String get getMeUrl => dotenv.env['API_GET_ME'] ?? '';
  
  // OTP endpoints
  static String get verifyOtpUrl => dotenv.env['API_VERIFY_OTP'] ?? '';
  static String get resendOtpUrl => dotenv.env['API_RESEND_OTP'] ?? '';
  
  // Other API endpoints
  static String get uploadImageUrl => dotenv.env['API_UPLOAD_IMAGE'] ?? '';
  
  // Legacy compatibility - keeping apiUrl for existing code
  static String get apiUrl => baseUrl;
}