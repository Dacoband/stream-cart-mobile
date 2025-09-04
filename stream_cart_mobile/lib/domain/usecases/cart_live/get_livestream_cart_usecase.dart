import 'dart:async';
import '../../../core/services/livestream_cart_service.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

class GetLivestreamCartUsecase {
  final LivestreamCartService cartService;
  GetLivestreamCartUsecase(this.cartService);

  Future<PreviewOrderLiveModel?> call(String livestreamId) async {  
    try {
      await cartService.loadCartWithRetry(livestreamId, maxRetries: 3);
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
