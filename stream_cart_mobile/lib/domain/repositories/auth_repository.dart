import 'package:dartz/dartz.dart';
import '../entities/auth/login_request_entity.dart';
import '../entities/auth/login_response_entity.dart';
import '../entities/auth/register_request_entity.dart';
import '../entities/auth/register_response_entity.dart';
import '../entities/auth/otp_entities.dart';
import '../../core/error/failures.dart';
import '../entities/auth/change_password_request_entity.dart';
import '../entities/auth/change_password_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login(LoginRequestEntity request);
  Future<Either<Failure, RegisterResponseEntity>> register(RegisterRequestEntity request);
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp(VerifyOtpRequestEntity request);
  Future<Either<Failure, ResendOtpResponseEntity>> resendOtp(ResendOtpRequestEntity request);
  Future<Either<Failure, LoginResponseEntity>> refreshToken(String refreshToken);
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<String?> getStoredRefreshToken();
  Future<void> saveUserEmail(String email);
  Future<String?> getStoredUserEmail();
  Future<void> saveAccountId(String accountId); // Add this method
  Future<String?> getStoredAccountId(); // Add this method
  Future<Either<Failure, ChangePasswordResponseEntity>> changePassword(ChangePasswordRequestEntity request);
}
