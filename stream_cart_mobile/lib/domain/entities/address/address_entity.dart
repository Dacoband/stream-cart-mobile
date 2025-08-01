import 'package:equatable/equatable.dart';
import '../../core/enums/address_type.dart';

class AddressEntity extends Equatable {
  static const String defaultCountry = 'Việt Nam';
  static const String defaultPostalCode = '70000';

  final String id;
  final String recipientName;
  final String street;
  final String ward;
  final String district;
  final String city;
  final String country;
  final String postalCode;
  final String phoneNumber;
  final bool isDefaultShipping;
  final double latitude;
  final double longitude;
  final AddressType type;
  final bool isActive;
  final String accountId;
  final String? shopId;
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastModifiedAt;
  final String lastModifiedBy;

  const AddressEntity({
    required this.id,
    required this.recipientName,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    this.country = defaultCountry,
    this.postalCode = defaultPostalCode,
    required this.phoneNumber,
    required this.isDefaultShipping,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.isActive,
    required this.accountId,
    this.shopId,
    required this.createdAt,
    required this.createdBy,
    required this.lastModifiedAt,
    required this.lastModifiedBy,
  });

  // Factory constructor for creating new address with defaults
  factory AddressEntity.create({
    required String id,
    required String recipientName,
    required String street,
    required String ward,
    required String district,
    required String city,
    String? country,
    String? postalCode,
    required String phoneNumber,
    required bool isDefaultShipping,
    required double latitude,
    required double longitude,
    required AddressType type,
    required bool isActive,
    required String accountId,
    String? shopId,
    required DateTime createdAt,
    required String createdBy,
    required DateTime lastModifiedAt,
    required String lastModifiedBy,
  }) {
    return AddressEntity(
      id: id,
      recipientName: recipientName,
      street: street,
      ward: ward,
      district: district,
      city: city,
      country: country ?? defaultCountry,
      postalCode: postalCode ?? defaultPostalCode,
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
  List<Object?> get props => [
        id,
        recipientName,
        street,
        ward,
        district,
        city,
        country,
        postalCode,
        phoneNumber,
        isDefaultShipping,
        latitude,
        longitude,
        type,
        isActive,
        accountId,
        shopId,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
      ];

  AddressEntity copyWith({
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
    return AddressEntity(
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

  String get fullAddress {
    return '$street, $ward, $district, $city, $country';
  }

  bool get hasValidCoordinates {
    return latitude != 0.0 && longitude != 0.0;
  }
}

class ProvinceEntity extends Equatable {
  final String id;
  final String fullName;
  final String name;

  const ProvinceEntity({
    required this.id,
    required this.fullName,
    required this.name,
  });

  @override
  List<Object> get props => [id, fullName, name];
}

class WardEntity extends Equatable {
  final String id;
  final String fullName;
  final String latitude;
  final String longitude;

  const WardEntity({
    required this.id,
    required this.fullName,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [id, fullName, latitude, longitude];
}