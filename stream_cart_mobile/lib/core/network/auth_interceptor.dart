import 'package:dio/dio.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;
  final Dio? _refreshDio; 

  AuthInterceptor(this._storageService, [this._refreshDio]);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token to requests if available
    final token = await _storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('Authorization header added');
    } else {
      print('No token available - request without auth');
    }   
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      
      try {
        // Get refresh token
        final refreshToken = await _storageService.getRefreshToken();
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final refreshResult = await _performTokenRefresh(refreshToken);     
          if (refreshResult != null) {
            print('Token refresh successful!');
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
      final dio = Dio();
      dio.options.baseUrl = 'https://brightpa.me';
      
      final response = await dio.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'];
        final newRefreshToken = response.data['data']['refreshToken'];
        
        await _storageService.saveAccessToken(newToken);
        await _storageService.saveRefreshToken(newRefreshToken);
        
        return newToken;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  Future<void> _retryOriginalRequest(
    DioException err,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    try {
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      
      final retryDio = Dio();
      final response = await retryDio.fetch(err.requestOptions);
      
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}