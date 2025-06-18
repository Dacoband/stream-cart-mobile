import 'package:dartz/dartz.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login(LoginRequestEntity request);
  Future<Either<Failure, LoginResponseEntity>> refreshToken(String refreshToken);
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<String?> getStoredRefreshToken();
}
