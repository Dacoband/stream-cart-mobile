import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/payment/payment_entity.dart';
import '../../repositories/payment/payment_repository.dart';

class GeneratePaymentQrParams {
  final GeneratePaymentQrRequestEntity request;

  GeneratePaymentQrParams({required this.request});
}

class GeneratePaymentQrUseCase {
  final PaymentRepository repository;

  GeneratePaymentQrUseCase(this.repository);

  Future<Either<Failure, PaymentQrEntity>> call(GeneratePaymentQrParams params) async {
    return await repository.generatePaymentQr(params.request);
  }
}
