import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment/payment_entity.dart';

abstract class PaymentState extends Equatable {
	const PaymentState();
	@override
	List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
	const PaymentInitial();
}

class PaymentLoading extends PaymentState {
	const PaymentLoading();
}

class PaymentGenerating extends PaymentState {
	final GeneratePaymentQrRequestEntity request;
	const PaymentGenerating({required this.request});

	@override
	List<Object?> get props => [request];
}

class PaymentQrLoaded extends PaymentState {
	final PaymentQrEntity qr;
	const PaymentQrLoaded({required this.qr});

	@override
	List<Object?> get props => [qr];
}

class PaymentError extends PaymentState {
	final String message;
	const PaymentError({required this.message});

	@override
	List<Object?> get props => [message];
}

class PaymentOperationSuccess extends PaymentState {
	final String message;
	const PaymentOperationSuccess({required this.message});

	@override
	List<Object?> get props => [message];
}

