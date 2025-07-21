import '../config/env.dart';
import '../constants/api_constants.dart';

class ApiUrlHelper {
  /// Get full URL from environment or construct from base URL + endpoint
  static String getAuthUrl(String endpoint) {
    switch (endpoint) {
      case ApiConstants.loginEndpoint:
        return Env.loginUrl.isNotEmpty ? Env.loginUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.refreshTokenEndpoint:
        return Env.refreshTokenUrl.isNotEmpty ? Env.refreshTokenUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.signupEndpoint:
        return Env.registerUrl.isNotEmpty ? Env.registerUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.verifyAccountEndpoint:
        return Env.verifyAccountUrl.isNotEmpty ? Env.verifyAccountUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.resetPasswordRequestEndpoint:
        return Env.resetPasswordRequestUrl.isNotEmpty ? Env.resetPasswordRequestUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.resetPasswordEndpoint:
        return Env.resetPasswordUrl.isNotEmpty ? Env.resetPasswordUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.changePasswordEndpoint:
        return Env.changePasswordUrl.isNotEmpty ? Env.changePasswordUrl : '${Env.baseUrl}$endpoint';
      case ApiConstants.getMeEndpoint:
        return Env.getMeUrl.isNotEmpty ? Env.getMeUrl : '${Env.baseUrl}$endpoint';
      default:
        return '${Env.baseUrl}$endpoint';
    }
  }
  
  /// Get full URL for image uploads
  static String getImageUrl(String endpoint) {
    switch (endpoint) {
      case ApiConstants.uploadImageEndpoint:
        return Env.uploadImageUrl.isNotEmpty ? Env.uploadImageUrl : '${Env.baseUrl}$endpoint';
      default:
        return '${Env.baseUrl}$endpoint';
    }
  }
  
  /// Get endpoint path only (for use with Dio that already has baseUrl)
  static String getEndpoint(String endpoint) {
    // Return just the endpoint path, not full URL
    return endpoint;
  }
  
  /// Get full URL for any endpoint
  static String getFullUrl(String endpoint) {
    if (endpoint.startsWith('/api/auth')) {
      return getAuthUrl(endpoint);
    } else if (endpoint.startsWith('/api/image')) {
      return getImageUrl(endpoint);
    } else {
      return '${Env.baseUrl}$endpoint';
    }
  }
  
  /// Check if we should use environment-specific URLs or construct from base
  static bool get useEnvironmentUrls {
    return Env.loginUrl.isNotEmpty || 
           Env.registerUrl.isNotEmpty || 
           Env.refreshTokenUrl.isNotEmpty;
  }
}
