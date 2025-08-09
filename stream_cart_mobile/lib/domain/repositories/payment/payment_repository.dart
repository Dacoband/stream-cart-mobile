import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/payment/payment_entity.dart';

abstract class PaymentRepository {
	Future<Either<Failure, PaymentQrEntity>> generatePaymentQr(
		GeneratePaymentQrRequestEntity request,
	);
}