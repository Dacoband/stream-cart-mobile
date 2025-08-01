import 'package:dartz/dartz.dart';
import '../entities/register_request_entity.dart';
import '../entities/register_response_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/failures.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, RegisterResponseEntity>> call(RegisterRequestEntity request) async {
    return await repository.register(request);
  }
}
