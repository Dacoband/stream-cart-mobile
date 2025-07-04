import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(UserProfileEntity profile);
}
