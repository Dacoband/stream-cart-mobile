import '../../../core/services/livestream_cart_service.dart';

class ClearLivestreamCartUsecase {
  final LivestreamCartService cartService;
  ClearLivestreamCartUsecase(this.cartService);

  Future<void> call({
    required String livestreamId,
  }) async {
  await cartService.clearCart(livestreamId);
  }
}
