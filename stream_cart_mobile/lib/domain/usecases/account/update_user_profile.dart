import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/account/user_profile_entity.dart';
import '../../repositories/profile_repository.dart';
import '../../../data/models/account/update_profile_model.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.userId, params.request);
  }
}

class UpdateUserProfileParams {
  final String userId;
  final UpdateProfileRequestModel request;

  UpdateUserProfileParams({
    required this.userId,
    required this.request,
  });
}
