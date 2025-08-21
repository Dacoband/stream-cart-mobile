import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';

part 'shop_voucher_model.g.dart';

@JsonSerializable()
class ShopVoucherModel extends ShopVoucherEntity {
	const ShopVoucherModel({
		required super.id,
		required super.shopId,
		required super.code,
		super.description,
		required super.type,
		super.typeDisplayName,
		required super.value,
		super.maxValue,
		super.minOrderAmount,
		super.startDate,
		super.endDate,
		required super.availableQuantity,
		required super.usedQuantity,
		required super.remainingQuantity,
		required super.isActive,
		required super.isValid,
		required super.isExpired,
		super.createdAt,
		super.createdBy,
		super.lastModifiedAt,
		super.lastModifiedBy,
		super.shopName,
	});

	factory ShopVoucherModel.fromJson(Map<String, dynamic> json) =>
			_$ShopVoucherModelFromJson(json);
	Map<String, dynamic> toJson() => _$ShopVoucherModelToJson(this);

	ShopVoucherEntity toEntity() {
		return ShopVoucherEntity(
			id: id,
			shopId: shopId,
			code: code,
			description: description,
			type: type,
			typeDisplayName: typeDisplayName,
			value: value,
			maxValue: maxValue,
			minOrderAmount: minOrderAmount,
			startDate: startDate,
			endDate: endDate,
			availableQuantity: availableQuantity,
			usedQuantity: usedQuantity,
			remainingQuantity: remainingQuantity,
			isActive: isActive,
			isValid: isValid,
			isExpired: isExpired,
			createdAt: createdAt,
			createdBy: createdBy,
			lastModifiedAt: lastModifiedAt,
			lastModifiedBy: lastModifiedBy,
			shopName: shopName,
		);
	}

	factory ShopVoucherModel.fromEntity(ShopVoucherEntity entity) {
		return ShopVoucherModel(
			id: entity.id,
			shopId: entity.shopId,
			code: entity.code,
			description: entity.description,
			type: entity.type,
			typeDisplayName: entity.typeDisplayName,
			value: entity.value,
			maxValue: entity.maxValue,
			minOrderAmount: entity.minOrderAmount,
			startDate: entity.startDate,
			endDate: entity.endDate,
			availableQuantity: entity.availableQuantity,
			usedQuantity: entity.usedQuantity,
			remainingQuantity: entity.remainingQuantity,
			isActive: entity.isActive,
			isValid: entity.isValid,
			isExpired: entity.isExpired,
			createdAt: entity.createdAt,
			createdBy: entity.createdBy,
			lastModifiedAt: entity.lastModifiedAt,
			lastModifiedBy: entity.lastModifiedBy,
			shopName: entity.shopName,
		);
	}

	ShopVoucherModel copyWith({
		String? id,
		String? shopId,
		String? code,
		String? description,
		int? type,
		String? typeDisplayName,
		double? value,
		double? maxValue,
		double? minOrderAmount,
		DateTime? startDate,
		DateTime? endDate,
		int? availableQuantity,
		int? usedQuantity,
		int? remainingQuantity,
		bool? isActive,
		bool? isValid,
		bool? isExpired,
		DateTime? createdAt,
		String? createdBy,
		DateTime? lastModifiedAt,
		String? lastModifiedBy,
		String? shopName,
	}) {
		return ShopVoucherModel(
			id: id ?? this.id,
			shopId: shopId ?? this.shopId,
			code: code ?? this.code,
			description: description ?? this.description,
			type: type ?? this.type,
			typeDisplayName: typeDisplayName ?? this.typeDisplayName,
			value: value ?? this.value,
			maxValue: maxValue ?? this.maxValue,
			minOrderAmount: minOrderAmount ?? this.minOrderAmount,
			startDate: startDate ?? this.startDate,
			endDate: endDate ?? this.endDate,
			availableQuantity: availableQuantity ?? this.availableQuantity,
			usedQuantity: usedQuantity ?? this.usedQuantity,
			remainingQuantity: remainingQuantity ?? this.remainingQuantity,
			isActive: isActive ?? this.isActive,
			isValid: isValid ?? this.isValid,
			isExpired: isExpired ?? this.isExpired,
			createdAt: createdAt ?? this.createdAt,
			createdBy: createdBy ?? this.createdBy,
			lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
			lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
			shopName: shopName ?? this.shopName,
		);
	}
}

@JsonSerializable(explicitToJson: true)
class ShopVouchersPaginatedModel {
	@JsonKey(name: 'currentPage')
	final int currentPage;
	@JsonKey(name: 'pageSize')
	final int pageSize;
	@JsonKey(name: 'totalCount')
	final int totalCount;
	@JsonKey(name: 'totalPages')
	final int totalPages;
	@JsonKey(name: 'hasPrevious')
	final bool hasPrevious;
	@JsonKey(name: 'hasNext')
	final bool hasNext;
	@JsonKey(name: 'items')
	final List<ShopVoucherModel> items;

	const ShopVouchersPaginatedModel({
		required this.currentPage,
		required this.pageSize,
		required this.totalCount,
		required this.totalPages,
		required this.hasPrevious,
		required this.hasNext,
		required this.items,
	});

	factory ShopVouchersPaginatedModel.fromJson(Map<String, dynamic> json) =>
			_$ShopVouchersPaginatedModelFromJson(json);
	Map<String, dynamic> toJson() => _$ShopVouchersPaginatedModelToJson(this);

	ShopVouchersPaginatedEntity toEntity() {
		return ShopVouchersPaginatedEntity(
			currentPage: currentPage,
			pageSize: pageSize,
			totalCount: totalCount,
			totalPages: totalPages,
			hasPrevious: hasPrevious,
			hasNext: hasNext,
			items: items.map((e) => e.toEntity()).toList(),
		);
	}

	factory ShopVouchersPaginatedModel.fromEntity(
			ShopVouchersPaginatedEntity entity) {
		return ShopVouchersPaginatedModel(
			currentPage: entity.currentPage,
			pageSize: entity.pageSize,
			totalCount: entity.totalCount,
			totalPages: entity.totalPages,
			hasPrevious: entity.hasPrevious,
			hasNext: entity.hasNext,
			items: entity.items.map((e) => ShopVoucherModel.fromEntity(e)).toList(),
		);
	}
}

@JsonSerializable(explicitToJson: true)
class ShopVouchersResponseModel {
	@JsonKey(name: 'success')
	final bool success;
	@JsonKey(name: 'message')
	final String message;
	@JsonKey(name: 'data')
	final ShopVouchersPaginatedModel? data;
	@JsonKey(name: 'errors')
	final List<String> errors;

	const ShopVouchersResponseModel({
		required this.success,
		required this.message,
		this.data,
		required this.errors,
	});

	factory ShopVouchersResponseModel.fromJson(Map<String, dynamic> json) =>
			_$ShopVouchersResponseModelFromJson(json);
	Map<String, dynamic> toJson() => _$ShopVouchersResponseModelToJson(this);

	ShopVouchersResponseEntity toEntity() {
		return ShopVouchersResponseEntity(
			success: success,
			message: message,
			data: data?.toEntity(),
			errors: errors,
		);
	}

	factory ShopVouchersResponseModel.fromEntity(
			ShopVouchersResponseEntity entity) {
		return ShopVouchersResponseModel(
			success: entity.success,
			message: entity.message,
			data:
					entity.data != null ? ShopVouchersPaginatedModel.fromEntity(entity.data!) : null,
			errors: entity.errors,
		);
	}
}

class ApplyShopVoucherRequestModel {
	final String code;
	final double orderAmount;
	final String? orderId;

	const ApplyShopVoucherRequestModel({
		required this.code,
		required this.orderAmount,
		this.orderId,
	});

	factory ApplyShopVoucherRequestModel.fromJson(Map<String, dynamic> json) {
		return ApplyShopVoucherRequestModel(
			code: json['code'] ?? '',
			orderAmount: (json['orderAmount'] as num?)?.toDouble() ?? 0,
			orderId: (json['orderId'] as String?),
		);
	}

	Map<String, dynamic> toJson() {
		final map = <String, dynamic>{
			'code': code,
			'orderAmount': orderAmount,
		};
		if (orderId != null && orderId!.isNotEmpty) {
			map['orderId'] = orderId;
		}
		return map;
	}

	factory ApplyShopVoucherRequestModel.fromEntity(
			ApplyShopVoucherRequestEntity entity) {
		return ApplyShopVoucherRequestModel(
			code: entity.code,
			orderAmount: entity.orderAmount,
			orderId: entity.orderId,
		);
	}

	ApplyShopVoucherRequestEntity toEntity() => ApplyShopVoucherRequestEntity(
				code: code,
				orderAmount: orderAmount,
				orderId: orderId,
			);
}

@JsonSerializable()
class ApplyShopVoucherDataModel {
	@JsonKey(name: 'isApplied')
	final bool isApplied;
	@JsonKey(name: 'message')
	final String message;
	@JsonKey(name: 'discountAmount')
	final double discountAmount;
	@JsonKey(name: 'finalAmount')
	final double finalAmount;
	@JsonKey(name: 'voucherId')
	final String voucherId;
	@JsonKey(name: 'voucherCode')
	final String voucherCode;
	@JsonKey(name: 'appliedAt')
	final DateTime? appliedAt;

	const ApplyShopVoucherDataModel({
		required this.isApplied,
		required this.message,
		required this.discountAmount,
		required this.finalAmount,
		required this.voucherId,
		required this.voucherCode,
		this.appliedAt,
	});

	factory ApplyShopVoucherDataModel.fromJson(Map<String, dynamic> json) =>
			_$ApplyShopVoucherDataModelFromJson(json);
	Map<String, dynamic> toJson() => _$ApplyShopVoucherDataModelToJson(this);

	ApplyShopVoucherDataEntity toEntity() => ApplyShopVoucherDataEntity(
				isApplied: isApplied,
				message: message,
				discountAmount: discountAmount,
				finalAmount: finalAmount,
				voucherId: voucherId,
				voucherCode: voucherCode,
				appliedAt: appliedAt,
			);

	factory ApplyShopVoucherDataModel.fromEntity(
			ApplyShopVoucherDataEntity entity) {
		return ApplyShopVoucherDataModel(
			isApplied: entity.isApplied,
			message: entity.message,
			discountAmount: entity.discountAmount,
			finalAmount: entity.finalAmount,
			voucherId: entity.voucherId,
			voucherCode: entity.voucherCode,
			appliedAt: entity.appliedAt,
		);
	}
}

@JsonSerializable(explicitToJson: true)
class ApplyShopVoucherResponseModel {
	@JsonKey(name: 'success')
	final bool success;
	@JsonKey(name: 'message')
	final String message;
	@JsonKey(name: 'data')
	final ApplyShopVoucherDataModel? data;
	@JsonKey(name: 'errors')
	final List<String> errors;

	const ApplyShopVoucherResponseModel({
		required this.success,
		required this.message,
		this.data,
		required this.errors,
	});

	factory ApplyShopVoucherResponseModel.fromJson(Map<String, dynamic> json) =>
			_$ApplyShopVoucherResponseModelFromJson(json);
	Map<String, dynamic> toJson() => _$ApplyShopVoucherResponseModelToJson(this);

	ApplyShopVoucherResponseEntity toEntity() => ApplyShopVoucherResponseEntity(
				success: success,
				message: message,
				data: data?.toEntity(),
				errors: errors,
			);

	factory ApplyShopVoucherResponseModel.fromEntity(
			ApplyShopVoucherResponseEntity entity) {
		return ApplyShopVoucherResponseModel(
			success: entity.success,
			message: entity.message,
			data: entity.data != null
					? ApplyShopVoucherDataModel.fromEntity(entity.data!)
					: null,
			errors: entity.errors,
		);
	}
}

