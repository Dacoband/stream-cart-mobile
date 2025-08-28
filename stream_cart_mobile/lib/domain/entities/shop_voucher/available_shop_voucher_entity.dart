import 'package:equatable/equatable.dart';
import 'shop_voucher_entity.dart';

class AvailableShopVoucherItemEntity extends Equatable {
  final ShopVoucherEntity voucher;
  final double discountAmount;
  final double finalAmount;
  final double discountPercentage;
  final String discountMessage;

  const AvailableShopVoucherItemEntity({
    required this.voucher,
    required this.discountAmount,
    required this.finalAmount,
    required this.discountPercentage,
    required this.discountMessage,
  });

  factory AvailableShopVoucherItemEntity.fromJson(Map<String, dynamic> json) {
    return AvailableShopVoucherItemEntity(
      voucher: ShopVoucherEntity.fromJson(json['voucher'] as Map<String, dynamic>),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      discountMessage: json['discountMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'voucher': voucher.toJson(),
        'discountAmount': discountAmount,
        'finalAmount': finalAmount,
        'discountPercentage': discountPercentage,
        'discountMessage': discountMessage,
      };

  @override
  List<Object?> get props => [voucher, discountAmount, finalAmount, discountPercentage, discountMessage];
}

class AvailableShopVouchersResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<AvailableShopVoucherItemEntity> data;
  final List<String> errors;

  const AvailableShopVouchersResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory AvailableShopVouchersResponseEntity.fromJson(Map<String, dynamic> json) {
    return AvailableShopVouchersResponseEntity(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AvailableShopVoucherItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: (json['errors'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
        'errors': errors,
      };

  @override
  List<Object?> get props => [success, message, data, errors];
}