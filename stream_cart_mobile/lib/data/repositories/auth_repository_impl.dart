import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/login_request_model.dart';

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
      print('AuthRepository: Starting login process');
      final loginRequest = LoginRequestModel.fromEntity(request);
      print('AuthRepository: Calling remote data source');
      final response = await remoteDataSource.login(loginRequest);
      print('AuthRepository: Response received - success: ${response.success}');
      
      if (response.success && response.data != null) {
        print('AuthRepository: Login successful, saving tokens');
        // Save tokens to local storage
        await localDataSource.saveToken(response.data!.token);
        await localDataSource.saveRefreshToken(response.data!.refreshToken);
        
        print('AuthRepository: Tokens saved, returning success');
        return Right(response.data!.toEntity());
      } else {
        print('AuthRepository: Login failed - ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('AuthRepository: DioException - ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Invalid credentials'));
      } else if (e.response?.statusCode == 400) {
        return Left(ValidationFailure('Invalid input data'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('AuthRepository: Exception - $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> refreshToken(String refreshToken) async {
    try {
      final response = await remoteDataSource.refreshToken({'refreshToken': refreshToken});
      
      if (response.success && response.data != null) {
        // Save new tokens to local storage
        await localDataSource.saveToken(response.data!.token);
        await localDataSource.saveRefreshToken(response.data!.refreshToken);
        
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Refresh token expired'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
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
}
