import 'package:dio/dio.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  AuthInterceptor(this._storageService);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token to requests if available
    final token = await _storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear stored auth data if token is invalid
      await _storageService.clearAuthData();
      
      // You could also trigger a logout event here
      // or redirect to login screen
    }
    
    super.onError(err, handler);
  }
}