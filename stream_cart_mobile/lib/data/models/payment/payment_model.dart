import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/payment/payment_entity.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class GeneratePaymentQrRequestModel extends GeneratePaymentQrRequestEntity {
  const GeneratePaymentQrRequestModel({required super.orderIds});

  factory GeneratePaymentQrRequestModel.fromJson(Map<String, dynamic> json) =>
	  _$GeneratePaymentQrRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratePaymentQrRequestModelToJson(this);

  factory GeneratePaymentQrRequestModel.fromEntity(GeneratePaymentQrRequestEntity e) =>
	  GeneratePaymentQrRequestModel(orderIds: List<String>.from(e.orderIds));

  GeneratePaymentQrRequestEntity toEntity() =>
	  GeneratePaymentQrRequestEntity(orderIds: List<String>.from(orderIds));

  @override
  GeneratePaymentQrRequestModel copyWith({List<String>? orderIds}) =>
	  GeneratePaymentQrRequestModel(orderIds: orderIds ?? this.orderIds);
}
@JsonSerializable()
class PaymentQrModel extends PaymentQrEntity {
  const PaymentQrModel({required super.qrImageUrl});

  factory PaymentQrModel.fromJson(Map<String, dynamic> json) => _$PaymentQrModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentQrModelToJson(this);

  factory PaymentQrModel.fromEntity(PaymentQrEntity e) =>
    PaymentQrModel(qrImageUrl: e.qrImageUrl);

  PaymentQrEntity toEntity() => PaymentQrEntity(qrImageUrl: qrImageUrl);

  @override
  PaymentQrModel copyWith({String? qrImageUrl}) =>
    PaymentQrModel(qrImageUrl: qrImageUrl ?? this.qrImageUrl);
}

extension PaymentQrPlainMapper on String {
  PaymentQrEntity toPaymentQrEntity() => PaymentQrEntity(qrImageUrl: this);
  PaymentQrModel toPaymentQrModel() => PaymentQrModel(qrImageUrl: this);
}

