import 'package:dartz/dartz.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/failures.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call(LoginRequestEntity params) async {
    return await repository.login(params);
  }
}
