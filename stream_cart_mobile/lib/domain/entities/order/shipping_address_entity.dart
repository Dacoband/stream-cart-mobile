import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String ward;
  final String district;
  final String city;
  final String province;
  final String? postalCode;
  final String country;
  final String? state;
  final bool isDefault;

  const ShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    required this.ward,
    required this.district,
    required this.city,
    required this.province,
    this.postalCode,
    required this.country,
    this.state,
    required this.isDefault,
  });

  ShippingAddressEntity copyWith({
    String? fullName,
    String? phone,
    String? addressLine1,
    String? ward,
    String? district,
    String? city,
    String? province,
    String? postalCode,
    String? country,
    String? state,
    bool? isDefault,
  }) {
    return ShippingAddressEntity(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      state: state ?? this.state,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        addressLine1,
        ward,
        district,
        city,
        province,
        postalCode,
        country,
        state,
        isDefault,
      ];

  @override
  String toString() {
    return 'ShippingAddressEntity(fullName: $fullName, phone: $phone, addressLine1: $addressLine1, ward: $ward, district: $district, city: $city, province: $province, postalCode: $postalCode, country: $country, state: $state, isDefault: $isDefault)';
  }
}