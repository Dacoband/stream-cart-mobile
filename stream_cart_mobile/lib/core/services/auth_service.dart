import 'package:dartz/dartz.dart';
import '../../domain/entities/auth/login_request_entity.dart';
import '../../domain/entities/auth/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/failures.dart';
import '../utils/token_utils.dart';

class AuthService {
  final AuthRepository _authRepository;
  
  AuthService(this._authRepository);
  
  Future<Either<Failure, LoginResponseEntity>> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequestEntity(
      username: username,
      password: password,
    );
    
    return await _authRepository.login(request);
  }
  
  /// Refresh token with automatic expiry check
  Future<Either<Failure, LoginResponseEntity>> refreshToken() async {
    final refreshToken = await _authRepository.getStoredRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return Left(UnauthorizedFailure('No refresh token available'));
    }
    
    return await _authRepository.refreshToken(refreshToken);
  }
  
  /// Check if current token needs refresh
  Future<bool> shouldRefreshToken() async {
    final token = await _authRepository.getStoredToken();
    if (token == null || token.isEmpty) return false;
    
    return TokenUtils.isTokenExpired(token);
  }
  
  /// Refresh token if needed
  Future<Either<Failure, LoginResponseEntity>?> refreshTokenIfNeeded() async {
    if (await shouldRefreshToken()) {
      print('Token expired or expiring soon, refreshing...');
      return await refreshToken();
    }
    return null; // No refresh needed
  }
  
  Future<void> logout() async {
    await _authRepository.logout();
  }
  
  Future<bool> isAuthenticated() async {
    final token = await _authRepository.getStoredToken();
    if (token == null || token.isEmpty) return false;
    
    // Check if token is not expired
    return !TokenUtils.isTokenExpired(token);
  }
  
  Future<String?> getStoredToken() async {
    return await _authRepository.getStoredToken();
  }
  
  /// Get user ID from current token
  Future<String?> getCurrentUserId() async {
    final token = await getStoredToken();
    if (token == null) return null;
    
    return TokenUtils.getUserIdFromToken(token);
  }
}
