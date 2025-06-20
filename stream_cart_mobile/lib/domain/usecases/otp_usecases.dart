import 'package:dartz/dartz.dart';
import '../entities/otp_entities.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/failures.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, VerifyOtpResponseEntity>> call(VerifyOtpRequestEntity request) async {
    return await repository.verifyOtp(request);
  }
}

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<Either<Failure, ResendOtpResponseEntity>> call(ResendOtpRequestEntity request) async {
    return await repository.resendOtp(request);
  }
}
