import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class StorageService {
  final FlutterSecureStorage _secureStorage;

  StorageService(this._secureStorage);

  // Các key cho storage
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accountIdKey = 'account_id';

  // Lưu access token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  // Lấy access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  // Lưu refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  // Lấy refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // Lưu Account ID
  Future<void> saveAccountId(String accountId) async {
    await _secureStorage.write(key: _accountIdKey, value: accountId);
  }

  // Lấy user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _accountIdKey);
  }

  // Xóa tất cả thông tin đăng nhập khi logout
  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _accountIdKey);
  }
}