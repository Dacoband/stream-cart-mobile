import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/auth/change_password_request_entity.dart';
import '../../entities/auth/change_password_response_entity.dart';
import '../../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, ChangePasswordResponseEntity>> call(ChangePasswordRequestEntity request) async {
    return await repository.changePassword(request);
  }
}
