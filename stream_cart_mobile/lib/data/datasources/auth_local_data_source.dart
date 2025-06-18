import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage? secureStorage;
  
  AuthLocalDataSourceImpl(this.secureStorage);

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveToken(String token) async {
    try {
      if (secureStorage != null) {
        await secureStorage!.write(key: _tokenKey, value: token);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    }
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      if (secureStorage != null) {
        await secureStorage!.write(key: _refreshTokenKey, value: refreshToken);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      if (secureStorage != null) {
        return await secureStorage!.read(key: _tokenKey);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      if (secureStorage != null) {
        return await secureStorage!.read(key: _refreshTokenKey);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      if (secureStorage != null) {
        await secureStorage!.delete(key: _tokenKey);
        await secureStorage!.delete(key: _refreshTokenKey);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
    }
  }
}
