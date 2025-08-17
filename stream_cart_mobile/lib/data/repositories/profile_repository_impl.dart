import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/account/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/account/update_profile_model.dart';
import '../datasources/account/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      print('[ProfileRepository] Getting user profile...');
      final result = await remoteDataSource.getUserProfile();
      print('[ProfileRepository] Successfully got user profile: ${result.fullname}');
      return Right(result.toEntity());
    } catch (e) {
      print('[ProfileRepository] Error getting user profile: $e');
      return Left(ServerFailure('Failed to get user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(String userId, UpdateProfileRequestModel request) async {
    try {
      print('[ProfileRepository] Updating user profile...');
      final result = await remoteDataSource.updateUserProfile(userId, request);
      
      if (result.success && result.data != null) {
        print('[ProfileRepository] Successfully updated user profile');
        return Right(result.data!.toEntity());
      } else {
        return Left(ServerFailure(result.message));
      }
    } catch (e) {
      print('[ProfileRepository] Error updating user profile: $e');
      return Left(ServerFailure('Failed to update user profile: ${e.toString()}'));
    }
  }
}
