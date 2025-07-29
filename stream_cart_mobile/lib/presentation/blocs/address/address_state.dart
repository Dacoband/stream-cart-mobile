import 'package:equatable/equatable.dart';
import '../../../domain/entities/address_entity.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {
  const AddressInitial();
}

class AddressLoading extends AddressState {
  const AddressLoading();
}

class AddressError extends AddressState {
  final String message;

  const AddressError({required this.message});

  @override
  List<Object> get props => [message];
}

class AddressesLoaded extends AddressState {
  final List<AddressEntity> addresses;

  const AddressesLoaded({required this.addresses});

  @override
  List<Object> get props => [addresses];
}

class AddressCreated extends AddressState {
  final AddressEntity address;

  const AddressCreated({required this.address});

  @override
  List<Object> get props => [address];
}

class AddressUpdated extends AddressState {
  final AddressEntity address;

  const AddressUpdated({required this.address});

  @override
  List<Object> get props => [address];
}

class AddressDeleted extends AddressState {
  final String deletedAddressId;

  const AddressDeleted({required this.deletedAddressId});

  @override
  List<Object> get props => [deletedAddressId];
}

class AddressLoaded extends AddressState {
  final AddressEntity address;

  const AddressLoaded({required this.address});

  @override
  List<Object> get props => [address];
}

class DefaultShippingAddressSet extends AddressState {
  final AddressEntity address;

  const DefaultShippingAddressSet({required this.address});

  @override
  List<Object> get props => [address];
}

class DefaultShippingAddressLoaded extends AddressState {
  final AddressEntity? address;

  const DefaultShippingAddressLoaded({this.address});

  @override
  List<Object?> get props => [address];
}

class AddressesByTypeLoaded extends AddressState {
  final List<AddressEntity> addresses;

  const AddressesByTypeLoaded({required this.addresses});

  @override
  List<Object> get props => [addresses];
}

class AddressAssignedToShop extends AddressState {
  final AddressEntity address;

  const AddressAssignedToShop({required this.address});

  @override
  List<Object> get props => [address];
}

class AddressUnassignedFromShop extends AddressState {
  final AddressEntity address;

  const AddressUnassignedFromShop({required this.address});

  @override
  List<Object> get props => [address];
}

class AddressesByShopLoaded extends AddressState {
  final List<AddressEntity> addresses;

  const AddressesByShopLoaded({required this.addresses});

  @override
  List<Object> get props => [addresses];
}

class ProvincesLoaded extends AddressState {
  final List<ProvinceEntity> provinces;

  const ProvincesLoaded({required this.provinces});

  @override
  List<Object> get props => [provinces];
}

class DistrictsLoaded extends AddressState {
  final List<ProvinceEntity> districts;

  const DistrictsLoaded({required this.districts});

  @override
  List<Object> get props => [districts];
}

class WardsLoaded extends AddressState {
  final List<WardEntity> wards;

  const WardsLoaded({required this.wards});

  @override
  List<Object> get props => [wards];
}

// Combined State for complex UI
class AddressStateData extends AddressState {
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final AddressEntity? defaultShippingAddress;
  final List<ProvinceEntity> provinces;
  final List<ProvinceEntity> districts;
  final List<WardEntity> wards;
  final bool isLoading;
  final String? error;

  const AddressStateData({
    this.addresses = const [],
    this.selectedAddress,
    this.defaultShippingAddress,
    this.provinces = const [],
    this.districts = const [],
    this.wards = const [],
    this.isLoading = false,
    this.error,
  });

  AddressStateData copyWith({
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    AddressEntity? defaultShippingAddress,
    List<ProvinceEntity>? provinces,
    List<ProvinceEntity>? districts,
    List<WardEntity>? wards,
    bool? isLoading,
    String? error,
  }) {
    return AddressStateData(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      defaultShippingAddress: defaultShippingAddress ?? this.defaultShippingAddress,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      wards: wards ?? this.wards,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  AddressStateData clearError() {
    return copyWith(error: null);
  }

  AddressStateData setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  @override
  List<Object?> get props => [
        addresses,
        selectedAddress,
        defaultShippingAddress,
        provinces,
        districts,
        wards,
        isLoading,
        error,
      ];
}