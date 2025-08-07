import 'package:equatable/equatable.dart';
import '../../../domain/entities/address/address_entity.dart';
import '../../../domain/entities/cart/cart_entity.dart';

abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object?> get props => [];
}

class PreviewOrderDeliveryEvent extends DeliveryEvent {
  final PreviewOrderDataEntity previewOrderData;
  final AddressEntity shippingAddress;

  const PreviewOrderDeliveryEvent({
    required this.previewOrderData,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [previewOrderData, shippingAddress];
}

class ChangeShippingAddressEvent extends DeliveryEvent {
  final AddressEntity newAddress;
  final PreviewOrderDataEntity previewOrderData;

  const ChangeShippingAddressEvent({
    required this.newAddress,
    required this.previewOrderData,
  });

  @override
  List<Object?> get props => [newAddress, previewOrderData];
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