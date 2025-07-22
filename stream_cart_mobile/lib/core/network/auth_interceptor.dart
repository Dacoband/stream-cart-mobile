import 'package:dio/dio.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;
  final Dio? _refreshDio; // Separate Dio instance for refresh requests

  AuthInterceptor(this._storageService, [this._refreshDio]);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token to requests if available
    final token = await _storageService.getAccessToken();
    
    print('=== AUTH INTERCEPTOR DEBUG ===');
    print('Request URL: ${options.baseUrl}${options.path}');
    print('Token exists: ${token != null}');
    print('Token length: ${token?.length ?? 0}');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('Authorization header added');
    } else {
      print('No token available - request without auth');
    }
    print('================================');
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 unauthorized errors with automatic token refresh
    if (err.response?.statusCode == 401) {
      print('=== 401 UNAUTHORIZED - ATTEMPTING TOKEN REFRESH ===');
      
      try {
        // Get refresh token
        final refreshToken = await _storageService.getRefreshToken();
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          print('Refresh token found, attempting refresh...');
          
          // Use a separate Dio instance to avoid interceptor loops
          final refreshResult = await _performTokenRefresh(refreshToken);
          
          if (refreshResult != null) {
            print('Token refresh successful!');
            // Retry the original request with new token
            await _retryOriginalRequest(err, handler, refreshResult);
          } else {
            print('Token refresh failed');
            await _storageService.clearAuthData();
            handler.next(err);
          }
        } else {
          print('No refresh token available, clearing auth data');
          await _storageService.clearAuthData();
          handler.next(err);
        }
      } catch (e) {
        print('Error during token refresh: $e');
        await _storageService.clearAuthData();
        handler.next(err);
      }
    } else {
      super.onError(err, handler);
    }
  }
  
  Future<String?> _performTokenRefresh(String refreshToken) async {
    try {
      final dio = Dio(); // Clean Dio instance without interceptors
      dio.options.baseUrl = 'https://brightpa.me';
      
      final response = await dio.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'];
        final newRefreshToken = response.data['data']['refreshToken'];
        
        // Save new tokens
        await _storageService.saveAccessToken(newToken);
        await _storageService.saveRefreshToken(newRefreshToken);
        
        return newToken;
      }
      
      return null;
    } catch (e) {
      print('Direct refresh request failed: $e');
      return null;
    }
  }
  
  Future<void> _retryOriginalRequest(
    DioException err,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    try {
      // Update the request with new token
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      
      // Create a clean Dio instance for retry
      final retryDio = Dio();
      
      // Retry the request with updated options
      final response = await retryDio.fetch(err.requestOptions);
      
      // Return successful response
      handler.resolve(response);
    } catch (e) {
      // If retry fails, pass the original error
      handler.next(err);
    }
  }
}