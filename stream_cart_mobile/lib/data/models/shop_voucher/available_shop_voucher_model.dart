import '../../../domain/entities/shop_voucher/available_shop_voucher_entity.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';

class AvailableShopVoucherItemModel extends AvailableShopVoucherItemEntity {
  const AvailableShopVoucherItemModel({
    required super.voucher,
    required super.discountAmount,
    required super.finalAmount,
    required super.discountPercentage,
    required super.discountMessage,
  });

  factory AvailableShopVoucherItemModel.fromJson(Map<String, dynamic> json) {
    final voucherJson = json['voucher'] as Map<String, dynamic>? ?? const {};
    double _num(dynamic v) => (v is num) ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0;
    return AvailableShopVoucherItemModel(
      voucher: ShopVoucherEntity.fromJson(voucherJson),
      discountAmount: _num(json['discountAmount']),
      finalAmount: _num(json['finalAmount']),
      discountPercentage: _num(json['discountPercentage']),
      discountMessage: (json['discountMessage'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'voucher': (voucher).toJson(),
        'discountAmount': discountAmount,
        'finalAmount': finalAmount,
        'discountPercentage': discountPercentage,
        'discountMessage': discountMessage,
      };

  AvailableShopVoucherItemEntity toEntity() => AvailableShopVoucherItemEntity(
        voucher: voucher,
        discountAmount: discountAmount,
        finalAmount: finalAmount,
        discountPercentage: discountPercentage,
        discountMessage: discountMessage,
      );
}

class AvailableShopVouchersResponseModel extends AvailableShopVouchersResponseEntity {
  const AvailableShopVouchersResponseModel({
    required super.success,
    required super.message,
    required super.data,
    required super.errors,
  });

  factory AvailableShopVouchersResponseModel.fromJson(Map<String, dynamic> json) {
    return AvailableShopVouchersResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AvailableShopVoucherItemModel.fromJson(e as Map<String, dynamic>).toEntity())
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

  AvailableShopVouchersResponseEntity toEntity() => AvailableShopVouchersResponseEntity(
        success: success,
        message: message,
        data: data,
        errors: errors,
      );
}