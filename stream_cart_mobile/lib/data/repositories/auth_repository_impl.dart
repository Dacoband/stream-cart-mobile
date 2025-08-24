import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/auth/login_request_entity.dart';
import '../../domain/entities/auth/login_response_entity.dart';
import '../../domain/entities/auth/register_request_entity.dart';
import '../../domain/entities/auth/register_response_entity.dart';
import '../../domain/entities/auth/otp_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/api_url_helper.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/auth/auth_remote_data_source.dart';
import '../datasources/auth/auth_local_data_source.dart';
import '../models/auth/login_request_model.dart';
import '../models/auth/register_request_model.dart';
import '../models/auth/otp_models.dart';
import '../models/auth/change_password_model.dart';
import '../../domain/entities/auth/change_password_request_entity.dart';
import '../../domain/entities/auth/change_password_response_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LoginResponseEntity>> login(LoginRequestEntity request) async {
    try {
      final loginRequest = LoginRequestModel.fromEntity(request);
      final response = await remoteDataSource.login(loginRequest);
      
      if (response.success && response.data != null) {
        if (response.data!.account.isVerified) {
          await localDataSource.saveToken(response.data!.token);
          await localDataSource.saveRefreshToken(response.data!.refreshToken);
          return Right(response.data!.toEntity());
        } else {
          await localDataSource.saveAccountId(response.data!.account.id);
          await localDataSource.saveUserEmail(response.data!.account.email);
          return Right(response.data!.toEntity());
        }
      } else {
        if (response.message.toLowerCase().contains('verification') || 
            response.message.toLowerCase().contains('verify')) {
          
          String? accountId;
          if (response.rawData != null) {
            accountId = response.rawData!['accountId'] as String?;
          }
          
          if (accountId == null) {
            return Left(ServerFailure('Account verification required but account ID not found'));
          }
          
          await localDataSource.saveAccountId(accountId);
          final emailToSave = '${request.username}@placeholder.com';
          await localDataSource.saveUserEmail(emailToSave);
          
          return Left(UnauthorizedFailure('VERIFICATION_REQUIRED'));
        }
        
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Invalid credentials'));
      } else if (e.response?.statusCode == 403) {
        final responseData = e.response?.data;
        if (responseData != null && responseData['message']?.toString().toLowerCase().contains('verify') == true) {
          return Left(UnauthorizedFailure('VERIFICATION_REQUIRED'));
        }
        return Left(UnauthorizedFailure('Access forbidden'));
      } else if (e.response?.statusCode == 400) {
        return Left(ValidationFailure('Invalid input data'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> refreshToken(String refreshToken) async {
    try {
      print('=== REFRESH TOKEN REQUEST ===');
      print('Refresh Token Length: ${refreshToken.length}');
      print('Endpoint: ${ApiUrlHelper.getAuthUrl(ApiConstants.refreshTokenEndpoint)}');
      
      final response = await remoteDataSource.refreshToken({'refreshToken': refreshToken});
      
      print('Refresh Response Success: ${response.success}');
      print('Response Message: ${response.message}');
      
      if (response.success && response.data != null) {
        // Save new tokens
        await localDataSource.saveToken(response.data!.token);
        await localDataSource.saveRefreshToken(response.data!.refreshToken);
        
        print('New tokens saved successfully');
        return Right(response.data!.toEntity());
      } else {
        print('Refresh failed: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('Refresh DioException: ${e.response?.statusCode} - ${e.message}');
      
      if (e.response?.statusCode == 401) {
        // Refresh token is expired or invalid
        await localDataSource.clearTokens();
        return Left(UnauthorizedFailure('Refresh token expired or invalid'));
      } else if (e.response?.statusCode == 403) {
        // Refresh token is forbidden
        await localDataSource.clearTokens();
        return Left(UnauthorizedFailure('Refresh token forbidden'));
      } else {
        return Left(NetworkFailure('Network error during token refresh'));
      }
    } catch (e) {
      print('Refresh unexpected error: $e');
      return Left(ServerFailure('Unexpected error during token refresh: $e'));
    }
  }

  @override
  Future<Either<Failure, RegisterResponseEntity>> register(RegisterRequestEntity request) async {
    try {
      final registerRequest = RegisterRequestModel.fromEntity(request);
      final response = await remoteDataSource.register(registerRequest);
      if (response.success) {
        await localDataSource.saveUserEmail(request.email);
        if (response.data?.id != null) {
          await localDataSource.saveAccountId(response.data!.id);
        }
        return Right(response.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(ValidationFailure('Invalid registration data'));
      } else if (e.response?.statusCode == 409) {
        return Left(ConflictFailure('User already exists'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }  }

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp(VerifyOtpRequestEntity request) async {
    try {
      final verifyRequest = VerifyOtpRequestModel.fromEntity(request);
      final response = await remoteDataSource.verifyOtp(verifyRequest);
      if (response.success) {
        return Right(response.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(ValidationFailure('Invalid OTP'));
      } else if (e.response?.statusCode == 410) {
        return Left(ExpiredFailure('OTP has expired'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }  }

  @override
  Future<Either<Failure, ResendOtpResponseEntity>> resendOtp(ResendOtpRequestEntity request) async {
    try {
      final resendRequest = ResendOtpRequestModel.fromEntity(request);
      final response = await remoteDataSource.resendOtp(resendRequest);
      if (response.success) {
        return Right(response.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        return Left(TooManyRequestsFailure('Too many requests. Please wait before resending.'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<void> saveUserEmail(String email) async {
    await localDataSource.saveUserEmail(email);
  }

  @override
  Future<String?> getStoredUserEmail() async {
    return await localDataSource.getUserEmail();
  }

  @override
  Future<void> saveAccountId(String accountId) async {
    await localDataSource.saveAccountId(accountId);
  }

  @override
  Future<String?> getStoredAccountId() async {
    return await localDataSource.getAccountId();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearTokens();
  }

  @override
  Future<String?> getStoredToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<String?> getStoredRefreshToken() async {
    return await localDataSource.getRefreshToken();
  }

  @override
  Future<Either<Failure, ChangePasswordResponseEntity>> changePassword(ChangePasswordRequestEntity request) async {
    try {
      final model = ChangePasswordRequestModel.fromEntity(request);
      final response = await remoteDataSource.changePassword(model);
      if (response.success) {
        return Right(response.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final dynamic data = e.response?.data;
        final String msg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Yêu cầu không hợp lệ';
        return Left(ValidationFailure(msg));
      } else if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Mật khẩu hiện tại không đúng hoặc phiên hết hạn'));
      }
      return Left(NetworkFailure('Lỗi mạng khi đổi mật khẩu'));
    } catch (e) {
      return Left(ServerFailure('Không thể đổi mật khẩu: $e'));
    }
  }
}
