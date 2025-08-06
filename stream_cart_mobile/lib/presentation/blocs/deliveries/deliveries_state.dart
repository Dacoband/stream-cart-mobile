import 'package:equatable/equatable.dart';
import '../../../domain/entities/deliveries/preview_deliveries_response_entity.dart';
import '../../../domain/entities/deliveries/service_response_entity.dart';
import '../../../domain/entities/address/address_entity.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();

  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {
  const DeliveryInitial();
}

class DeliveryLoading extends DeliveryState {
  const DeliveryLoading();
}

class DeliveryLoaded extends DeliveryState {
  final PreviewDeliveriesResponseEntity deliveryPreview;
  final AddressEntity shippingAddress;
  final Map<String, ServiceResponseEntity> selectedServices;
  final double totalDeliveryFee;

  const DeliveryLoaded({
    required this.deliveryPreview,
    required this.shippingAddress,
    this.selectedServices = const {},
    this.totalDeliveryFee = 0.0,
  });

  @override
  List<Object?> get props => [
    deliveryPreview,
    shippingAddress,
    selectedServices,
    totalDeliveryFee,
  ];

  DeliveryLoaded copyWith({
    PreviewDeliveriesResponseEntity? deliveryPreview,
    AddressEntity? shippingAddress,
    Map<String, ServiceResponseEntity>? selectedServices,
    double? totalDeliveryFee,
  }) {
    return DeliveryLoaded(
      deliveryPreview: deliveryPreview ?? this.deliveryPreview,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      selectedServices: selectedServices ?? this.selectedServices,
      totalDeliveryFee: totalDeliveryFee ?? this.totalDeliveryFee,
    );
  }

  // Helper methods
  bool hasSelectedServiceForShop(String shopId) {
    return selectedServices.containsKey(shopId);
  }

  ServiceResponseEntity? getSelectedServiceForShop(String shopId) {
    return selectedServices[shopId];
  }

  bool get hasSelectedAllServices {
    final uniqueShopIds = deliveryPreview.serviceResponses
        .map((service) => service.shopId)
        .toSet();
    return uniqueShopIds.length == selectedServices.length;
  }
}

class DeliveryError extends DeliveryState {
  final String message;

  const DeliveryError({required this.message});

  @override
  List<Object?> get props => [message];
}