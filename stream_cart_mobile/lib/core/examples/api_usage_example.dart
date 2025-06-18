import '../config/env.dart';
import '../utils/api_url_helper.dart';
import '../constants/api_constants.dart';

/// Example class showing how to use the updated Env and API configuration
class ApiUsageExample {
  
  /// Example: How to get URLs for authentication endpoints
  static void demonstrateAuthEndpoints() {
    print('=== Auth Endpoints ===');
    
    // Method 1: Using direct environment URLs (preferred)
    print('Login URL (from .env): ${Env.loginUrl}');
    print('Register URL (from .env): ${Env.registerUrl}');
    print('Refresh Token URL (from .env): ${Env.refreshTokenUrl}');
    
    // Method 2: Using ApiUrlHelper (automatically chooses .env or constructs from base)
    print('\n=== Using ApiUrlHelper ===');
    print('Login: ${ApiUrlHelper.getAuthUrl(ApiConstants.loginEndpoint)}');
    print('Register: ${ApiUrlHelper.getAuthUrl(ApiConstants.signupEndpoint)}');
    print('Refresh Token: ${ApiUrlHelper.getAuthUrl(ApiConstants.refreshTokenEndpoint)}');
    print('Get Me: ${ApiUrlHelper.getAuthUrl(ApiConstants.getMeEndpoint)}');
    
    // Method 3: Fallback URLs (when .env values are empty)
    print('\n=== Fallback URLs ===');
    print('Base URL: ${Env.baseUrl}');
    print('Constructed Login URL: ${Env.baseUrl}${ApiConstants.loginEndpoint}');
  }
  
  /// Example: How to use different types of endpoints
  static void demonstrateAllEndpoints() {
    print('\n=== All Endpoint Types ===');
    
    // Auth endpoints
    print('Auth endpoints:');
    print('- Login: ${ApiUrlHelper.getFullUrl(ApiConstants.loginEndpoint)}');
    print('- Verify: ${ApiUrlHelper.getFullUrl(ApiConstants.verifyAccountEndpoint)}');
    print('- Reset Password: ${ApiUrlHelper.getFullUrl(ApiConstants.resetPasswordEndpoint)}');
    
    // Image endpoints
    print('\nImage endpoints:');
    print('- Upload: ${ApiUrlHelper.getFullUrl(ApiConstants.uploadImageEndpoint)}');
    
    // Other endpoints (will use base URL + endpoint)
    print('\nOther endpoints:');
    print('- Products: ${ApiUrlHelper.getFullUrl(ApiConstants.productsEndpoint)}');
    print('- Cart: ${ApiUrlHelper.getFullUrl(ApiConstants.cartEndpoint)}');
    print('- Orders: ${ApiUrlHelper.getFullUrl(ApiConstants.ordersEndpoint)}');
  }
  
  /// Example: Configuration check
  static void checkConfiguration() {
    print('\n=== Configuration Check ===');
    print('Using environment-specific URLs: ${ApiUrlHelper.useEnvironmentUrls}');
    print('Base URL: ${Env.baseUrl}');
    print('API Key: ${Env.apiKey.isNotEmpty ? "✓ Set" : "✗ Not set"}');
      // Check which URLs are configured in .env
    final envUrls = <String, String>{
      'Login URL': Env.loginUrl,
      'Register URL': Env.registerUrl,
      'Refresh Token URL': Env.refreshTokenUrl,
      'Verify Account URL': Env.verifyAccountUrl,
      'Upload Image URL': Env.uploadImageUrl,
    };
    
    print('\n.env URL Configuration:');
    envUrls.forEach((key, value) {
      print('- $key: ${value.isNotEmpty ? "✓ $value" : "✗ Not configured"}');
    });
  }
}

/// How to use in your app:
/// 
/// ```dart
/// // In main.dart or anywhere you need to check configuration
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Load environment
///   await Env.load();
///   
///   // Optional: Check configuration in debug mode
///   if (kDebugMode) {
///     ApiUsageExample.demonstrateAuthEndpoints();
///     ApiUsageExample.demonstrateAllEndpoints();
///     ApiUsageExample.checkConfiguration();
///   }
///   
///   runApp(MyApp());
/// }
/// 
/// // In your API services
/// class ApiService {
///   Future<Response> login(Map<String, dynamic> data) async {
///     final url = ApiUrlHelper.getAuthUrl(ApiConstants.loginEndpoint);
///     return await dio.post(url, data: data);
///   }
/// }
/// ```
