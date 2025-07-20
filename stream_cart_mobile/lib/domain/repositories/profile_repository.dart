import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';
import '../../data/models/update_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(String userId, UpdateProfileRequestModel request);
}
