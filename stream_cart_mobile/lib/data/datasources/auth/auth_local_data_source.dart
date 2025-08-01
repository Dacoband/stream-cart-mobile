import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<void> saveUserEmail(String email);
  Future<void> saveAccountId(String accountId); // Add this method
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserEmail();
  Future<String?> getAccountId(); // Add this method
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage? secureStorage;
  
  AuthLocalDataSourceImpl(this.secureStorage);
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';
  static const String _accountIdKey = 'account_id'; // Add this key

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
  Future<void> saveUserEmail(String email) async {
    try {
      if (secureStorage != null) {
        await secureStorage!.write(key: _userEmailKey, value: email);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
    }
  }

  @override
  Future<String?> getUserEmail() async {
    try {
      if (secureStorage != null) {
        return await secureStorage!.read(key: _userEmailKey);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    }
  }

  @override
  Future<void> saveAccountId(String accountId) async {
    try {
      if (secureStorage != null) {
        await secureStorage!.write(key: _accountIdKey, value: accountId);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accountIdKey, accountId);
    }
  }

  @override
  Future<String?> getAccountId() async {
    try {
      if (secureStorage != null) {
        return await secureStorage!.read(key: _accountIdKey);
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accountIdKey);
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      if (secureStorage != null) {
        await secureStorage!.delete(key: _tokenKey);
        await secureStorage!.delete(key: _refreshTokenKey);
        await secureStorage!.delete(key: _userEmailKey);
        await secureStorage!.delete(key: _accountIdKey); // Clear account ID as well
      } else {
        throw Exception('SecureStorage not available');
      }
    } catch (e) {
      // Fallback to SharedPreferences if SecureStorage fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_accountIdKey); // Remove account ID from SharedPreferences
    }
  }
}
