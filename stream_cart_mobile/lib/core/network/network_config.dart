import 'package:dio/dio.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';
import '../services/storage_service.dart';

class NetworkConfig {
  static Dio createDio({StorageService? storageService}) {
    final dio = Dio();
    dio.options.baseUrl = Env.baseUrl;
    // Timeout configuration
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
    if (storageService != null) {
      dio.interceptors.add(AuthInterceptor(storageService));
    }
    
    return dio;
  }
}
