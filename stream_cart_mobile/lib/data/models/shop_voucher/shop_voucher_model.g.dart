// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopVoucherModel _$ShopVoucherModelFromJson(Map<String, dynamic> json) =>
    ShopVoucherModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      type: (json['type'] as num).toInt(),
      typeDisplayName: json['typeDisplayName'] as String?,
      value: (json['value'] as num).toDouble(),
      maxValue: (json['maxValue'] as num?)?.toDouble(),
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      availableQuantity: (json['availableQuantity'] as num).toInt(),
      usedQuantity: (json['usedQuantity'] as num).toInt(),
      remainingQuantity: (json['remainingQuantity'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isValid: json['isValid'] as bool,
      isExpired: json['isExpired'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      lastModifiedAt: json['lastModifiedAt'] == null
          ? null
          : DateTime.parse(json['lastModifiedAt'] as String),
      lastModifiedBy: json['lastModifiedBy'] as String?,
      shopName: json['shopName'] as String?,
    );

Map<String, dynamic> _$ShopVoucherModelToJson(ShopVoucherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'code': instance.code,
      'description': instance.description,
      'type': instance.type,
      'typeDisplayName': instance.typeDisplayName,
      'value': instance.value,
      'maxValue': instance.maxValue,
      'minOrderAmount': instance.minOrderAmount,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'availableQuantity': instance.availableQuantity,
      'usedQuantity': instance.usedQuantity,
      'remainingQuantity': instance.remainingQuantity,
      'isActive': instance.isActive,
      'isValid': instance.isValid,
      'isExpired': instance.isExpired,
      'createdAt': instance.createdAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'lastModifiedAt': instance.lastModifiedAt?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'shopName': instance.shopName,
    };

ShopVouchersPaginatedModel _$ShopVouchersPaginatedModelFromJson(
        Map<String, dynamic> json) =>
    ShopVouchersPaginatedModel(
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasPrevious: json['hasPrevious'] as bool,
      hasNext: json['hasNext'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => ShopVoucherModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShopVouchersPaginatedModelToJson(
        ShopVouchersPaginatedModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPages': instance.totalPages,
      'hasPrevious': instance.hasPrevious,
      'hasNext': instance.hasNext,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

ShopVouchersResponseModel _$ShopVouchersResponseModelFromJson(
        Map<String, dynamic> json) =>
    ShopVouchersResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ShopVouchersPaginatedModel.fromJson(
              json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ShopVouchersResponseModelToJson(
        ShopVouchersResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
      'errors': instance.errors,
    };

ApplyShopVoucherDataModel _$ApplyShopVoucherDataModelFromJson(
        Map<String, dynamic> json) =>
    ApplyShopVoucherDataModel(
      isApplied: json['isApplied'] as bool,
      message: json['message'] as String,
      discountAmount: (json['discountAmount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      voucherId: json['voucherId'] as String,
      voucherCode: json['voucherCode'] as String,
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
    );

Map<String, dynamic> _$ApplyShopVoucherDataModelToJson(
        ApplyShopVoucherDataModel instance) =>
    <String, dynamic>{
      'isApplied': instance.isApplied,
      'message': instance.message,
      'discountAmount': instance.discountAmount,
      'finalAmount': instance.finalAmount,
      'voucherId': instance.voucherId,
      'voucherCode': instance.voucherCode,
      'appliedAt': instance.appliedAt?.toIso8601String(),
    };

ApplyShopVoucherResponseModel _$ApplyShopVoucherResponseModelFromJson(
        Map<String, dynamic> json) =>
    ApplyShopVoucherResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ApplyShopVoucherDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ApplyShopVoucherResponseModelToJson(
        ApplyShopVoucherResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
      'errors': instance.errors,
    };
