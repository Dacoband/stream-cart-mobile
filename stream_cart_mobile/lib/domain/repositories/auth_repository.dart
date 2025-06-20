import 'package:dartz/dartz.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../entities/register_request_entity.dart';
import '../entities/register_response_entity.dart';
import '../entities/otp_entities.dart';
import '../../core/error/failures.dart';

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
}
