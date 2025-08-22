import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/usecases/cart_live/get_preview_order_live_usecase.dart';
import '../../../domain/entities/cart_live/preview_order_live_entity.dart';
import '../../../domain/entities/cart/cart_entity.dart';

part 'preview_order_live_event.dart';
part 'preview_order_live_state.dart';

class PreviewOrderLiveBloc extends Bloc<PreviewOrderLiveEvent, PreviewOrderLiveState> {
  final GetPreviewOrderLiveUsecase getPreviewOrderLiveUsecase;
  PreviewOrderLiveBloc({required this.getPreviewOrderLiveUsecase}) : super(PreviewOrderLiveInitial()) {
    on<RequestPreviewOrderLiveEvent>(_onRequest, transformer: _debounceTransformer());
    on<RefreshPreviewOrderLiveEvent>(_onRefresh);
  }

  EventTransformer<T> _debounceTransformer<T>() {
    return (events, mapper) => events.debounceTime(const Duration(milliseconds: 350)).asyncExpand(mapper);
  }

  Future<void> _onRequest(RequestPreviewOrderLiveEvent event, Emitter<PreviewOrderLiveState> emit) async {
    if (event.cartItemIds.isEmpty) {
      emit(PreviewOrderLiveEmpty());
      return;
    }
    emit(PreviewOrderLiveLoading());
    final result = await getPreviewOrderLiveUsecase(event.cartItemIds);
    result.fold(
      (failure) => emit(PreviewOrderLiveError(failure.message)),
      (entity) => emit(PreviewOrderLiveLoaded(entity)),
    );
  }

  Future<void> _onRefresh(RefreshPreviewOrderLiveEvent event, Emitter<PreviewOrderLiveState> emit) async {
    final currentIds = event.cartItemIds;
    if (currentIds.isEmpty) {
      emit(PreviewOrderLiveEmpty());
      return;
    }
    final previous = state is PreviewOrderLiveLoaded ? (state as PreviewOrderLiveLoaded).data : null;
    emit(PreviewOrderLiveRefreshing(previous));
    final result = await getPreviewOrderLiveUsecase(currentIds);
    result.fold(
      (failure) => emit(PreviewOrderLiveError(failure.message)),
      (entity) => emit(PreviewOrderLiveLoaded(entity)),
    );
  }
}

extension PreviewOrderLiveAdapter on PreviewOrderLiveEntity {
  PreviewOrderDataEntity toPreviewOrderDataEntity() {
    return PreviewOrderDataEntity(
      totalItem: totalItem,
      subTotal: subTotal,
      discount: discount,
      totalAmount: totalAmount,
      length: null,
      width: null,
      height: null,
      listCartItem: listCartItem.map((shop) {
        return CartShopEntity(
          shopId: shop.shopId,
          shopName: shop.shopName,
          products: shop.products.map((p) => CartItemEntity(
            cartItemId: p.cartItemId,
            productId: p.productId,
            variantId: p.variantID,
            productName: p.productName,
            priceData: PriceDataEntity(
              currentPrice: p.priceData.currentPrice,
              originalPrice: p.priceData.originalPrice,
              discount: p.priceData.discount,
            ),
            quantity: p.quantity,
            primaryImage: p.primaryImage,
            attributes: p.attributes,
            stockQuantity: p.stockQuantity,
            productStatus: p.productStatus,
            weight: p.weight,
            length: p.length,
            width: p.width,
            height: p.height,
          )).toList(),
          numberOfProduct: shop.products.length,
          totalPriceInShop: shop.products.fold(0.0, (acc, p) => acc + (p.priceData.currentPrice * p.quantity)),
        );
      }).toList(),
    );
  }
}
