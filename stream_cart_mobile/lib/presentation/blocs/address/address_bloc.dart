import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/address/get_addresses_usecase.dart';
import '../../../domain/usecases/address/create_address_usecase.dart';
import '../../../domain/usecases/address/update_address_usecase.dart';
import '../../../domain/usecases/address/delete_address_usecase.dart';
import '../../../domain/usecases/address/get_address_by_id_usecase.dart';
import '../../../domain/usecases/address/set_default_shipping_address_usecase.dart';
import '../../../domain/usecases/address/get_default_shipping_address_usecase.dart';
import '../../../domain/usecases/address/get_addresses_by_type_usecase.dart';
import '../../../domain/usecases/address/assign_address_to_shop_usecase.dart';
import '../../../domain/usecases/address/get_addresses_by_shop_usecase.dart';
import '../../../domain/usecases/address/get_provinces_usecase.dart';
import '../../../domain/usecases/address/get_districts_usecase.dart';
import '../../../domain/usecases/address/get_wards_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final CreateAddressUseCase createAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final GetAddressByIdUseCase getAddressByIdUseCase;
  final SetDefaultShippingAddressUseCase setDefaultShippingAddressUseCase;
  final GetDefaultShippingAddressUseCase getDefaultShippingAddressUseCase;
  final GetAddressesByTypeUseCase getAddressesByTypeUseCase;
  final AssignAddressToShopUseCase assignAddressToShopUseCase;
  final GetAddressesByShopUseCase getAddressesByShopUseCase;
  final GetProvincesUseCase getProvincesUseCase;
  final GetDistrictsUseCase getDistrictsUseCase;
  final GetWardsUseCase getWardsUseCase;

  AddressBloc({
    required this.getAddressesUseCase,
    required this.createAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.getAddressByIdUseCase,
    required this.setDefaultShippingAddressUseCase,
    required this.getDefaultShippingAddressUseCase,
    required this.getAddressesByTypeUseCase,
    required this.assignAddressToShopUseCase,
    required this.getAddressesByShopUseCase,
    required this.getProvincesUseCase,
    required this.getDistrictsUseCase,
    required this.getWardsUseCase,
  }) : super(const AddressInitial()) {
    // Core CRUD Events
    on<GetAddressesEvent>(_onGetAddresses);
    on<CreateAddressEvent>(_onCreateAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<GetAddressByIdEvent>(_onGetAddressById);

    // Address Management Events
    on<SetDefaultShippingAddressEvent>(_onSetDefaultShippingAddress);
    on<GetDefaultShippingAddressEvent>(_onGetDefaultShippingAddress);
    on<GetAddressesByTypeEvent>(_onGetAddressesByType);

    // Shop Integration Events
    on<AssignAddressToShopEvent>(_onAssignAddressToShop);
    on<UnassignAddressFromShopEvent>(_onUnassignAddressFromShop);
    on<GetAddressesByShopEvent>(_onGetAddressesByShop);

    // Lấy provinces/districts/wards
    on<GetProvincesEvent>(_onGetProvinces);
    on<GetDistrictsEvent>(_onGetDistricts);
    on<GetWardsEvent>(_onGetWards);

    // UI Helper Events
    on<ResetAddressStateEvent>(_onResetAddressState);
    on<ClearAddressErrorEvent>(_onClearAddressError);
  }

  // Core CRUD Event Handlers
  Future<void> _onGetAddresses(GetAddressesEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getAddressesUseCase();
    result.fold(
      (failure) {
        emit(AddressError(message: failure.message));
      },
      (addresses) {
        emit(AddressesLoaded(addresses: addresses));
      },
    );
  }

  Future<void> _onCreateAddress(CreateAddressEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await createAddressUseCase(
      recipientName: event.recipientName,
      street: event.street,
      ward: event.ward,
      district: event.district,
      city: event.city,
      country: event.country,
      postalCode: event.postalCode,
      phoneNumber: event.phoneNumber,
      isDefaultShipping: event.isDefaultShipping,
      latitude: event.latitude,
      longitude: event.longitude,
      type: event.type,
      shopId: event.shopId,
    );
    
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressCreated(address: address)),
    );
  }

  Future<void> _onUpdateAddress(UpdateAddressEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await updateAddressUseCase(
      id: event.id,
      recipientName: event.recipientName,
      street: event.street,
      ward: event.ward,
      district: event.district,
      city: event.city,
      country: event.country,
      postalCode: event.postalCode,
      phoneNumber: event.phoneNumber,
      type: event.type,
      latitude: event.latitude,
      longitude: event.longitude,
    );
    
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressUpdated(address: address)),
    );
  }

  Future<void> _onDeleteAddress(DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await deleteAddressUseCase(event.id);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (_) => emit(AddressDeleted(deletedAddressId: event.id)),
    );
  }

  Future<void> _onGetAddressById(GetAddressByIdEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getAddressByIdUseCase(event.id);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressLoaded(address: address)),
    );
  }

  // Address Management Event Handlers
  Future<void> _onSetDefaultShippingAddress(SetDefaultShippingAddressEvent event, Emitter<AddressState> emit) async {
    // Giữ current state để update
    final currentState = state;
    if (currentState is! AddressesLoaded) {
      emit(const AddressLoading());
      // Nếu không có addresses đã load, load lại từ đầu
      add(const GetAddressesEvent());
      return;
    }
    
    final result = await setDefaultShippingAddressUseCase(event.id);
    result.fold(
      (failure) {
        emit(AddressError(message: failure.message));
      },
      (updatedAddress) {
        // Update local state: set tất cả addresses khác thành not default, set target address thành default
        final updatedAddresses = currentState.addresses.map((address) {
          if (address.id == event.id) {
            // Set address này thành default
            return address.copyWith(isDefaultShipping: true);
          } else {
            // Set tất cả addresses khác thành not default
            return address.copyWith(isDefaultShipping: false);
          }
        }).toList();
        
        emit(AddressesLoaded(addresses: updatedAddresses));
        emit(DefaultShippingAddressSet(address: updatedAddress));
      },
    );
  }

  Future<void> _onGetDefaultShippingAddress(GetDefaultShippingAddressEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getDefaultShippingAddressUseCase();
    result.fold(
      (failure) {
        emit(AddressError(message: failure.message));
      },
      (address) {
        emit(DefaultShippingAddressLoaded(address: address));
      },
    );
  }

  Future<void> _onGetAddressesByType(GetAddressesByTypeEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getAddressesByTypeUseCase(event.type);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (addresses) => emit(AddressesByTypeLoaded(addresses: addresses)),
    );
  }

  // Shop Integration Event Handlers
  Future<void> _onAssignAddressToShop(AssignAddressToShopEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await assignAddressToShopUseCase(event.addressId, event.shopId);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressAssignedToShop(address: address)),
    );
  }

  Future<void> _onUnassignAddressFromShop(UnassignAddressFromShopEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    // final result = await unassignAddressFromShopUseCase(event.addressId);
    emit(const AddressError(message: 'Unassign functionality not implemented yet'));
  }

  Future<void> _onGetAddressesByShop(GetAddressesByShopEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getAddressesByShopUseCase(event.shopId);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (addresses) => emit(AddressesByShopLoaded(addresses: addresses)),
    );
  }

  // Location API Event Handlers - Dùng API external esgoo.net
  Future<void> _onGetProvinces(GetProvincesEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getProvincesUseCase();
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (provinces) => emit(ProvincesLoaded(provinces: provinces)),
    );
  }

  Future<void> _onGetDistricts(GetDistrictsEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getDistrictsUseCase(event.provinceId);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (districts) => emit(DistrictsLoaded(districts: districts)),
    );
  }

  Future<void> _onGetWards(GetWardsEvent event, Emitter<AddressState> emit) async {
    emit(const AddressLoading());
    
    final result = await getWardsUseCase(event.districtId);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (wards) => emit(WardsLoaded(wards: wards)),
    );
  }

  // UI Helper Event Handlers
  Future<void> _onResetAddressState(ResetAddressStateEvent event, Emitter<AddressState> emit) async {
    emit(const AddressInitial());
  }

  Future<void> _onClearAddressError(ClearAddressErrorEvent event, Emitter<AddressState> emit) async {
    emit(const AddressInitial());
  }
}