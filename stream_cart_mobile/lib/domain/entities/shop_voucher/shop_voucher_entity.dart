import 'package:equatable/equatable.dart';

class ShopVoucherEntity extends Equatable {
	final String id;
	final String shopId;
	final String code;
	final String? description;
	final int type; // 1 = percentage, 2 = fixed amount
	final String? typeDisplayName;
	final double value;
	final double? maxValue;
	final double? minOrderAmount;
	final DateTime? startDate;
	final DateTime? endDate;
	final int availableQuantity;
	final int usedQuantity;
	final int remainingQuantity;
	final bool isActive;
	final bool isValid;
	final bool isExpired;
	final DateTime? createdAt;
	final String? createdBy;
	final DateTime? lastModifiedAt;
	final String? lastModifiedBy;
	final String? shopName;

	const ShopVoucherEntity({
		required this.id,
		required this.shopId,
		required this.code,
		this.description,
		required this.type,
		this.typeDisplayName,
		required this.value,
		this.maxValue,
		this.minOrderAmount,
		this.startDate,
		this.endDate,
		required this.availableQuantity,
		required this.usedQuantity,
		required this.remainingQuantity,
		required this.isActive,
		required this.isValid,
		required this.isExpired,
		this.createdAt,
		this.createdBy,
		this.lastModifiedAt,
		this.lastModifiedBy,
		this.shopName,
	});

	ShopVoucherEntity copyWith({
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
		return ShopVoucherEntity(
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

	factory ShopVoucherEntity.fromJson(Map<String, dynamic> json) {
		DateTime? _parseDate(dynamic v) {
			if (v == null) return null;
			try {
				return DateTime.parse(v.toString());
			} catch (_) {
				return null;
			}
		}

		return ShopVoucherEntity(
			id: json['id'] ?? '',
			shopId: json['shopId'] ?? '',
			code: json['code'] ?? '',
			description: json['description'],
			type: json['type'] is int ? json['type'] as int : int.tryParse('${json['type']}') ?? 0,
			typeDisplayName: json['typeDisplayName'],
			value: (json['value'] as num?)?.toDouble() ?? 0,
			maxValue: (json['maxValue'] as num?)?.toDouble(),
			minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble(),
			startDate: _parseDate(json['startDate']),
			endDate: _parseDate(json['endDate']),
			availableQuantity: json['availableQuantity'] ?? 0,
			usedQuantity: json['usedQuantity'] ?? 0,
			remainingQuantity: json['remainingQuantity'] ?? 0,
			isActive: json['isActive'] ?? false,
			isValid: json['isValid'] ?? false,
			isExpired: json['isExpired'] ?? false,
			createdAt: _parseDate(json['createdAt']),
			createdBy: json['createdBy'],
			lastModifiedAt: _parseDate(json['lastModifiedAt']),
			lastModifiedBy: json['lastModifiedBy'],
			shopName: json['shopName'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'shopId': shopId,
			'code': code,
			'description': description,
			'type': type,
			'typeDisplayName': typeDisplayName,
			'value': value,
			'maxValue': maxValue,
			'minOrderAmount': minOrderAmount,
			'startDate': startDate?.toIso8601String(),
			'endDate': endDate?.toIso8601String(),
			'availableQuantity': availableQuantity,
			'usedQuantity': usedQuantity,
			'remainingQuantity': remainingQuantity,
			'isActive': isActive,
			'isValid': isValid,
			'isExpired': isExpired,
			'createdAt': createdAt?.toIso8601String(),
			'createdBy': createdBy,
			'lastModifiedAt': lastModifiedAt?.toIso8601String(),
			'lastModifiedBy': lastModifiedBy,
			'shopName': shopName,
		};
	}

	@override
	List<Object?> get props => [
				id,
				shopId,
				code,
				description,
				type,
				typeDisplayName,
				value,
				maxValue,
				minOrderAmount,
				startDate,
				endDate,
				availableQuantity,
				usedQuantity,
				remainingQuantity,
				isActive,
				isValid,
				isExpired,
				createdAt,
				createdBy,
				lastModifiedAt,
				lastModifiedBy,
				shopName,
			];

	@override
	String toString() => 'ShopVoucherEntity(code: $code, type: $type, value: $value)';
}

class ShopVouchersPaginatedEntity extends Equatable {
	final int currentPage;
	final int pageSize;
	final int totalCount;
	final int totalPages;
	final bool hasPrevious;
	final bool hasNext;
	final List<ShopVoucherEntity> items;

	const ShopVouchersPaginatedEntity({
		required this.currentPage,
		required this.pageSize,
		required this.totalCount,
		required this.totalPages,
		required this.hasPrevious,
		required this.hasNext,
		required this.items,
	});

	ShopVouchersPaginatedEntity copyWith({
		int? currentPage,
		int? pageSize,
		int? totalCount,
		int? totalPages,
		bool? hasPrevious,
		bool? hasNext,
		List<ShopVoucherEntity>? items,
	}) {
		return ShopVouchersPaginatedEntity(
			currentPage: currentPage ?? this.currentPage,
			pageSize: pageSize ?? this.pageSize,
			totalCount: totalCount ?? this.totalCount,
			totalPages: totalPages ?? this.totalPages,
			hasPrevious: hasPrevious ?? this.hasPrevious,
			hasNext: hasNext ?? this.hasNext,
			items: items ?? this.items,
		);
	}

	factory ShopVouchersPaginatedEntity.fromJson(Map<String, dynamic> json) {
		return ShopVouchersPaginatedEntity(
			currentPage: json['currentPage'] ?? 1,
			pageSize: json['pageSize'] ?? 0,
			totalCount: json['totalCount'] ?? 0,
			totalPages: json['totalPages'] ?? 0,
			hasPrevious: json['hasPrevious'] ?? false,
			hasNext: json['hasNext'] ?? false,
			items: (json['items'] as List<dynamic>? ?? [])
					.map((e) => ShopVoucherEntity.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'currentPage': currentPage,
			'pageSize': pageSize,
			'totalCount': totalCount,
			'totalPages': totalPages,
			'hasPrevious': hasPrevious,
			'hasNext': hasNext,
			'items': items.map((e) => e.toJson()).toList(),
		};
	}

	@override
	List<Object?> get props => [
				currentPage,
				pageSize,
				totalCount,
				totalPages,
				hasPrevious,
				hasNext,
				items,
			];
}

class ShopVouchersResponseEntity extends Equatable {
	final bool success;
	final String message;
	final ShopVouchersPaginatedEntity? data;
	final List<String> errors;

	const ShopVouchersResponseEntity({
		required this.success,
		required this.message,
		this.data,
		required this.errors,
	});

	factory ShopVouchersResponseEntity.fromJson(Map<String, dynamic> json) {
		return ShopVouchersResponseEntity(
			success: json['success'] ?? false,
			message: json['message'] ?? '',
			data: json['data'] != null
					? ShopVouchersPaginatedEntity.fromJson(json['data'] as Map<String, dynamic>)
					: null,
			errors: (json['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'success': success,
			'message': message,
			'data': data?.toJson(),
			'errors': errors,
		};
	}

	@override
	List<Object?> get props => [success, message, data, errors];
}

class ApplyShopVoucherRequestEntity extends Equatable {
	final String code;
	final double orderAmount;
	final String orderId;

	const ApplyShopVoucherRequestEntity({
		required this.code,
		required this.orderAmount,
		required this.orderId,
	});

	ApplyShopVoucherRequestEntity copyWith({
		String? code,
		double? orderAmount,
		String? orderId,
	}) {
		return ApplyShopVoucherRequestEntity(
			code: code ?? this.code,
			orderAmount: orderAmount ?? this.orderAmount,
			orderId: orderId ?? this.orderId,
		);
	}

	Map<String, dynamic> toJson() => {
				'code': code,
				'orderAmount': orderAmount,
				'orderId': orderId,
			};

	@override
	List<Object?> get props => [code, orderAmount, orderId];
}

class ApplyShopVoucherDataEntity extends Equatable {
	final bool isApplied;
	final String message;
	final double discountAmount;
	final double finalAmount;
	final String voucherId;
	final String voucherCode;
	final DateTime? appliedAt;

	const ApplyShopVoucherDataEntity({
		required this.isApplied,
		required this.message,
		required this.discountAmount,
		required this.finalAmount,
		required this.voucherId,
		required this.voucherCode,
		this.appliedAt,
	});

	factory ApplyShopVoucherDataEntity.fromJson(Map<String, dynamic> json) {
		DateTime? _parseDate(dynamic v) {
			if (v == null) return null;
			try {
				return DateTime.parse(v.toString());
			} catch (_) {
				return null;
			}
		}

		return ApplyShopVoucherDataEntity(
			isApplied: json['isApplied'] ?? false,
			message: json['message'] ?? '',
			discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
			finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0,
			voucherId: json['voucherId'] ?? '',
			voucherCode: json['voucherCode'] ?? '',
			appliedAt: _parseDate(json['appliedAt']),
		);
	}

	Map<String, dynamic> toJson() => {
				'isApplied': isApplied,
				'message': message,
				'discountAmount': discountAmount,
				'finalAmount': finalAmount,
				'voucherId': voucherId,
				'voucherCode': voucherCode,
				'appliedAt': appliedAt?.toIso8601String(),
			};

	ApplyShopVoucherDataEntity copyWith({
		bool? isApplied,
		String? message,
		double? discountAmount,
		double? finalAmount,
		String? voucherId,
		String? voucherCode,
		DateTime? appliedAt,
	}) {
		return ApplyShopVoucherDataEntity(
			isApplied: isApplied ?? this.isApplied,
			message: message ?? this.message,
			discountAmount: discountAmount ?? this.discountAmount,
			finalAmount: finalAmount ?? this.finalAmount,
			voucherId: voucherId ?? this.voucherId,
			voucherCode: voucherCode ?? this.voucherCode,
			appliedAt: appliedAt ?? this.appliedAt,
		);
	}

	@override
	List<Object?> get props => [
				isApplied,
				message,
				discountAmount,
				finalAmount,
				voucherId,
				voucherCode,
				appliedAt,
			];
}

class ApplyShopVoucherResponseEntity extends Equatable {
	final bool success;
	final String message;
	final ApplyShopVoucherDataEntity? data;
	final List<String> errors;

	const ApplyShopVoucherResponseEntity({
		required this.success,
		required this.message,
		this.data,
		required this.errors,
	});

	factory ApplyShopVoucherResponseEntity.fromJson(Map<String, dynamic> json) {
		return ApplyShopVoucherResponseEntity(
			success: json['success'] ?? false,
			message: json['message'] ?? '',
			data: json['data'] != null
					? ApplyShopVoucherDataEntity.fromJson(json['data'] as Map<String, dynamic>)
					: null,
			errors: (json['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
		);
	}

	Map<String, dynamic> toJson() => {
				'success': success,
				'message': message,
				'data': data?.toJson(),
				'errors': errors,
			};

	@override
	List<Object?> get props => [success, message, data, errors];
}

