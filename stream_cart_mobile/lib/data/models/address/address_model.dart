import 'package:stream_cart_mobile/domain/entities/address/address_entity.dart';

import '../../../core/enums/address_type.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.recipientName,
    required super.street,
    required super.ward,
    required super.district,
    required super.city,
    super.country = AddressEntity.defaultCountry,
    super.postalCode = AddressEntity.defaultPostalCode,
    required super.phoneNumber,
    required super.isDefaultShipping,
    required super.latitude,
    required super.longitude,
    required super.type,
    required super.isActive,
    required super.accountId,
    super.shopId,
    required super.createdAt,
    required super.createdBy,
    required super.lastModifiedAt,
    required super.lastModifiedBy,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      recipientName: json['recipientName'] ?? '',
      street: json['street'] ?? '',
      ward: json['ward'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? AddressEntity.defaultCountry,
      postalCode: json['postalCode'] ?? AddressEntity.defaultPostalCode,
      phoneNumber: json['phoneNumber'] ?? '',
      isDefaultShipping: json['isDefaultShipping'] ?? false,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      type: AddressType.fromValue(json['type'] ?? 0),
      isActive: json['isActive'] ?? true,
      accountId: json['accountId'] ?? '',
      shopId: json['shopId'],
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      lastModifiedAt: json['lastModifiedAt'] != null 
        ? DateTime.parse(json['lastModifiedAt']) 
        : DateTime.now(),
      lastModifiedBy: json['lastModifiedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'isDefaultShipping': isDefaultShipping,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.value,
      'isActive': isActive,
      'accountId': accountId,
      'shopId': shopId,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      recipientName: entity.recipientName,
      street: entity.street,
      ward: entity.ward,
      district: entity.district,
      city: entity.city,
      country: entity.country,
      postalCode: entity.postalCode,
      phoneNumber: entity.phoneNumber,
      isDefaultShipping: entity.isDefaultShipping,
      latitude: entity.latitude,
      longitude: entity.longitude,
      type: entity.type,
      isActive: entity.isActive,
      accountId: entity.accountId,
      shopId: entity.shopId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      lastModifiedAt: entity.lastModifiedAt,
      lastModifiedBy: entity.lastModifiedBy,
    );
  }

  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      recipientName: recipientName,
      street: street,
      ward: ward,
      district: district,
      city: city,
      country: country,
      postalCode: postalCode,
      phoneNumber: phoneNumber,
      isDefaultShipping: isDefaultShipping,
      latitude: latitude,
      longitude: longitude,
      type: type,
      isActive: isActive,
      accountId: accountId,
      shopId: shopId,
      createdAt: createdAt,
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt,
      lastModifiedBy: lastModifiedBy,
    );
  }

  @override
  AddressModel copyWith({
    String? id,
    String? recipientName,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? country,
    String? postalCode,
    String? phoneNumber,
    bool? isDefaultShipping,
    double? latitude,
    double? longitude,
    AddressType? type,
    bool? isActive,
    String? accountId,
    String? shopId,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModifiedAt,
    String? lastModifiedBy,
  }) {
    return AddressModel(
      id: id ?? this.id,
      recipientName: recipientName ?? this.recipientName,
      street: street ?? this.street,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefaultShipping: isDefaultShipping ?? this.isDefaultShipping,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }
}

class ProvinceModel extends ProvinceEntity {
  const ProvinceModel({
    required super.id,
    required super.fullName,
    required super.name,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'name': name,
    };
  }

  factory ProvinceModel.fromEntity(ProvinceEntity entity) {
    return ProvinceModel(
      id: entity.id,
      fullName: entity.fullName,
      name: entity.name,
    );
  }

  ProvinceEntity toEntity() {
    return ProvinceEntity(
      id: id,
      fullName: fullName,
      name: name,
    );
  }
}

class WardModel extends WardEntity {
  const WardModel({
    required super.id,
    required super.fullName,
    required super.latitude,
    required super.longitude,
  });

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      latitude: json['latitude']?.toString() ?? '0.0',
      longitude: json['longitude']?.toString() ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory WardModel.fromEntity(WardEntity entity) {
    return WardModel(
      id: entity.id,
      fullName: entity.fullName,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  WardEntity toEntity() {
    return WardEntity(
      id: id,
      fullName: fullName,
      latitude: latitude,
      longitude: longitude,
    );
  }
}