import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/shipping_address_entity.dart';

part 'shipping_address_model.g.dart';

@JsonSerializable()
class ShippingAddressModel extends ShippingAddressEntity {
  const ShippingAddressModel({
    required super.fullName,
    required super.phone,
    required super.addressLine1,
    required super.ward,
    required super.district,
    required super.city,
    required super.province,
    super.postalCode,
    required super.country,
    super.state,
    required super.isDefault,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressModelToJson(this);

  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      fullName: fullName,
      phone: phone,
      addressLine1: addressLine1,
      ward: ward,
      district: district,
      city: city,
      province: province,
      postalCode: postalCode,
      country: country,
      state: state,
      isDefault: isDefault,
    );
  }

  factory ShippingAddressModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressModel(
      fullName: entity.fullName,
      phone: entity.phone,
      addressLine1: entity.addressLine1,
      ward: entity.ward,
      district: entity.district,
      city: entity.city,
      province: entity.province,
      postalCode: entity.postalCode,
      country: entity.country,
      state: entity.state,
      isDefault: entity.isDefault,
    );
  }

  ShippingAddressModel copyWith({
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
    return ShippingAddressModel(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShippingAddressModel &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.addressLine1 == addressLine1 &&
        other.ward == ward &&
        other.district == district &&
        other.city == city &&
        other.province == province &&
        other.postalCode == postalCode &&
        other.country == country &&
        other.state == state &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return Object.hash(
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
    );
  }

  @override
  String toString() {
    return 'ShippingAddressModel(fullName: $fullName, phone: $phone, addressLine1: $addressLine1, ward: $ward, district: $district, city: $city, province: $province, postalCode: $postalCode, country: $country, state: $state, isDefault: $isDefault)';
  }
}