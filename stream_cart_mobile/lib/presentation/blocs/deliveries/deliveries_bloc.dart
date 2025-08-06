import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/deliveries/preview_deliveries_entity.dart';
import '../../../domain/entities/deliveries/service_response_entity.dart';
import '../../../domain/usecases/deliveries/preview_order_delivery_usecase.dart';
import 'deliveries_event.dart';
import 'deliveries_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final PreviewOrderDeliveryUseCase previewOrderDeliveryUseCase;

  DeliveryBloc({
    required this.previewOrderDeliveryUseCase,
  }) : super(const DeliveryInitial()) {
    on<PreviewOrderDeliveryEvent>(_onPreviewOrderDelivery);
    on<ChangeShippingAddressEvent>(_onChangeShippingAddress);
    on<SelectDeliveryServiceEvent>(_onSelectDeliveryService);
    on<ClearSelectedServicesEvent>(_onClearSelectedServices);
    on<ResetDeliveryEvent>(_onResetDelivery);
  }

  Future<void> _onPreviewOrderDelivery(
    PreviewOrderDeliveryEvent event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());

    final deliveryRequest = PreviewDeliveriesEntity(
      fromShops: [],
      toProvince: event.shippingAddress.city,
      toDistrict: event.shippingAddress.district,
      toWard: event.shippingAddress.ward,
    );

    final result = await previewOrderDeliveryUseCase(deliveryRequest);

    result.fold(
      (failure) => emit(DeliveryError(message: failure.message)),
      (deliveryPreview) {
        final Map<String, ServiceResponseEntity> autoSelectedServices = {};
        final shopIds = deliveryPreview.serviceResponses
            .map((service) => service.shopId)
            .toSet();

        for (String shopId in shopIds) {
          final firstServiceForShop = deliveryPreview.serviceResponses
              .where((service) => service.shopId == shopId)
              .first;
          autoSelectedServices[shopId] = firstServiceForShop;
        }

        final totalFee = autoSelectedServices.values
            .fold<double>(0.0, (sum, service) => sum + service.totalAmount);

        emit(DeliveryLoaded(
          deliveryPreview: deliveryPreview,
          shippingAddress: event.shippingAddress,
          selectedServices: autoSelectedServices,
          totalDeliveryFee: totalFee,
        ));
      },
    );
  }

  Future<void> _onChangeShippingAddress(
    ChangeShippingAddressEvent event,
    Emitter<DeliveryState> emit,
  ) async {
    // Re-preview with new address
    add(PreviewOrderDeliveryEvent(
      cartItemIds: event.cartItemIds,
      shippingAddress: event.newAddress,
    ));
  }

  void _onSelectDeliveryService(
    SelectDeliveryServiceEvent event,
    Emitter<DeliveryState> emit,
  ) {
    if (state is DeliveryLoaded) {
      final currentState = state as DeliveryLoaded;
      
      final selectedService = currentState.deliveryPreview.serviceResponses
          .where((service) => 
              service.shopId == event.shopId && 
              service.serviceTypeId == event.serviceTypeId)
          .firstOrNull;

      if (selectedService != null) {
        final updatedSelectedServices = Map<String, ServiceResponseEntity>.from(
          currentState.selectedServices,
        );
        updatedSelectedServices[event.shopId] = selectedService;

        final totalFee = updatedSelectedServices.values
            .fold<double>(0.0, (sum, service) => sum + service.totalAmount);

        emit(currentState.copyWith(
          selectedServices: updatedSelectedServices,
          totalDeliveryFee: totalFee,
        ));
      }
    }
  }

  void _onClearSelectedServices(
    ClearSelectedServicesEvent event,
    Emitter<DeliveryState> emit,
  ) {
    if (state is DeliveryLoaded) {
      final currentState = state as DeliveryLoaded;
      emit(currentState.copyWith(
        selectedServices: {},
        totalDeliveryFee: 0.0,
      ));
    }
  }

  void _onResetDelivery(
    ResetDeliveryEvent event,
    Emitter<DeliveryState> emit,
  ) {
    emit(const DeliveryInitial());
  }
}