import 'package:equatable/equatable.dart';
import '../../../core/enums/address_type.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

// Core CRUD Events
class GetAddressesEvent extends AddressEvent {
  const GetAddressesEvent();
}

class CreateAddressEvent extends AddressEvent {
  final String recipientName;
  final String street;
  final String ward;
  final String district;
  final String city;
  final String? country;
  final String? postalCode;
  final String phoneNumber;
  final bool isDefaultShipping;
  final double latitude;
  final double longitude;
  final AddressType type;
  final String? shopId;

  const CreateAddressEvent({
    required this.recipientName,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    this.country,
    this.postalCode,
    required this.phoneNumber,
    required this.isDefaultShipping,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.shopId,
  });

  @override
  List<Object?> get props => [
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
        shopId,
      ];
}

class UpdateAddressEvent extends AddressEvent {
  final String id;
  final String? recipientName;
  final String? street;
  final String? ward;
  final String? district;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? phoneNumber;
  final AddressType? type;
  final double? latitude;
  final double? longitude;

  const UpdateAddressEvent({
    required this.id,
    this.recipientName,
    this.street,
    this.ward,
    this.district,
    this.city,
    this.country,
    this.postalCode,
    this.phoneNumber,
    this.type,
    this.latitude,
    this.longitude,
  });

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
        type,
        latitude,
        longitude,
      ];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;

  const DeleteAddressEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class GetAddressByIdEvent extends AddressEvent {
  final String id;

  const GetAddressByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class SetDefaultShippingAddressEvent extends AddressEvent {
  final String id;

  const SetDefaultShippingAddressEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class GetDefaultShippingAddressEvent extends AddressEvent {
  const GetDefaultShippingAddressEvent();
}

class GetAddressesByTypeEvent extends AddressEvent {
  final AddressType type;

  const GetAddressesByTypeEvent({required this.type});

  @override
  List<Object> get props => [type];
}

class AssignAddressToShopEvent extends AddressEvent {
  final String addressId;
  final String shopId;

  const AssignAddressToShopEvent({
    required this.addressId,
    required this.shopId,
  });

  @override
  List<Object> get props => [addressId, shopId];
}

class UnassignAddressFromShopEvent extends AddressEvent {
  final String addressId;

  const UnassignAddressFromShopEvent({required this.addressId});

  @override
  List<Object> get props => [addressId];
}

class GetAddressesByShopEvent extends AddressEvent {
  final String shopId;

  const GetAddressesByShopEvent({required this.shopId});

  @override
  List<Object> get props => [shopId];
}

class GetProvincesEvent extends AddressEvent {
  const GetProvincesEvent();
}

class GetDistrictsEvent extends AddressEvent {
  final String provinceId;

  const GetDistrictsEvent({required this.provinceId});

  @override
  List<Object> get props => [provinceId];
}

class GetWardsEvent extends AddressEvent {
  final String districtId;

  const GetWardsEvent({required this.districtId});

  @override
  List<Object> get props => [districtId];
}

// UI Helper Events
class ResetAddressStateEvent extends AddressEvent {
  const ResetAddressStateEvent();
}

class ClearAddressErrorEvent extends AddressEvent {
  const ClearAddressErrorEvent();
}

class SelectAddressEvent extends AddressEvent {
  final String addressId;

  const SelectAddressEvent({required this.addressId});

  @override
  List<Object> get props => [addressId];
}