import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment/payment_entity.dart';

abstract class PaymentEvent extends Equatable {
	const PaymentEvent();
	@override
	List<Object?> get props => [];
}

class GeneratePaymentQrEvent extends PaymentEvent {
	final GeneratePaymentQrRequestEntity request;
	const GeneratePaymentQrEvent({required this.request});

	@override
	List<Object?> get props => [request];
}

class ResetPaymentStateEvent extends PaymentEvent {
	const ResetPaymentStateEvent();
}

