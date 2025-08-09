import 'package:equatable/equatable.dart';

class GeneratePaymentQrRequestEntity extends Equatable {
	final List<String> orderIds;

	const GeneratePaymentQrRequestEntity({required this.orderIds});

	GeneratePaymentQrRequestEntity copyWith({List<String>? orderIds}) =>
			GeneratePaymentQrRequestEntity(orderIds: orderIds ?? this.orderIds);

	Map<String, dynamic> toJson() => {
				'orderIds': orderIds,
			};

	@override
	List<Object?> get props => [orderIds];

	@override
	String toString() => 'GeneratePaymentQrRequestEntity(orderIds: $orderIds)';
}

class PaymentQrEntity extends Equatable {
	final String qrImageUrl;

	const PaymentQrEntity({required this.qrImageUrl});

	bool get isValidUrl => Uri.tryParse(qrImageUrl)?.hasAbsolutePath == true;

	PaymentQrEntity copyWith({String? qrImageUrl}) =>
			PaymentQrEntity(qrImageUrl: qrImageUrl ?? this.qrImageUrl);

	@override
	List<Object?> get props => [qrImageUrl];

	@override
	String toString() => 'PaymentQrEntity(qrImageUrl: $qrImageUrl)';
}

