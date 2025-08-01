import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../entities/account/user_profile_entity.dart';
import '../../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call() {
    return repository.getUserProfile();
  }
}
