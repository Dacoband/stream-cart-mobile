import 'package:dio/dio.dart';
import '../network/network_config.dart';
import 'storage_service.dart';

class HttpService {
  static late Dio _dio;

  static void initialize({StorageService? storageService}) {
    _dio = NetworkConfig.createDio(storageService: storageService);
  }

  static Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  static Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return Exception('Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          return Exception('Server error: ${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('Request was cancelled');
        case DioExceptionType.unknown:
          return Exception('Network error. Please check your internet connection.');
        default:
          return Exception('Something went wrong: ${error.message}');
      }
    }
    return Exception('Unexpected error occurred');
  }
}
