import 'package:dio/dio.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';
import '../services/storage_service.dart';

class NetworkConfig {
  static Dio createDio({StorageService? storageService}) {
    final dio = Dio();
      // Base URL from environment
    dio.options.baseUrl = Env.baseUrl;
    
    // Timeout configuration
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Default headers
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
    
    // Add auth interceptor if storage service is provided
    if (storageService != null) {
      dio.interceptors.add(AuthInterceptor(storageService));
    }
    
    return dio;
  }
}
