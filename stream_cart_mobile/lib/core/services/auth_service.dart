import 'package:dartz/dartz.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/failures.dart';

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
  
  Future<Either<Failure, LoginResponseEntity>> refreshToken() async {
    final refreshToken = await _authRepository.getStoredRefreshToken();
    if (refreshToken == null) {
      return Left(UnauthorizedFailure('No refresh token available'));
    }
    
    return await _authRepository.refreshToken(refreshToken);
  }
  
  Future<void> logout() async {
    await _authRepository.logout();
  }
  
  Future<bool> isAuthenticated() async {
    final token = await _authRepository.getStoredToken();
    return token != null && token.isNotEmpty;
  }
  
  Future<String?> getStoredToken() async {
    return await _authRepository.getStoredToken();
  }
}
