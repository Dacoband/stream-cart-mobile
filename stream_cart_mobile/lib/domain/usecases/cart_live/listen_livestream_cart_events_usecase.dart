import '../../../core/services/livestream_cart_service.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

class ListenLivestreamCartEventsUsecase {
  final LivestreamCartService cartService;
  ListenLivestreamCartEventsUsecase(this.cartService);

  void listen({
    void Function(PreviewOrderLiveModel cart)? onLoaded,
    void Function(String action, PreviewOrderLiveModel cart, Map<String, dynamic> raw)? onUpdated,
    void Function(Map<String, dynamic> payload)? onCleared,
    void Function(String message)? onError,
  }) {
    if (onLoaded != null) cartService.onLoaded(onLoaded);
    if (onUpdated != null) cartService.onUpdated(onUpdated);
    if (onCleared != null) cartService.onCleared(onCleared);
    if (onError != null) cartService.onError(onError);
  }
}
