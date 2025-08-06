import 'package:equatable/equatable.dart';
import '../../../domain/entities/address/address_entity.dart';

abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object?> get props => [];
}

class PreviewOrderDeliveryEvent extends DeliveryEvent {
  final List<String> cartItemIds;
  final AddressEntity shippingAddress;

  const PreviewOrderDeliveryEvent({
    required this.cartItemIds,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [cartItemIds, shippingAddress];
}

class ChangeShippingAddressEvent extends DeliveryEvent {
  final AddressEntity newAddress;
  final List<String> cartItemIds;

  const ChangeShippingAddressEvent({
    required this.newAddress,
    required this.cartItemIds,
  });

  @override
  List<Object?> get props => [newAddress, cartItemIds];
}

class SelectDeliveryServiceEvent extends DeliveryEvent {
  final String shopId;
  final int serviceTypeId;

  const SelectDeliveryServiceEvent({
    required this.shopId,
    required this.serviceTypeId,
  });

  @override
  List<Object?> get props => [shopId, serviceTypeId];
}

class ClearSelectedServicesEvent extends DeliveryEvent {
  const ClearSelectedServicesEvent();
}

class ResetDeliveryEvent extends DeliveryEvent {
  const ResetDeliveryEvent();
}