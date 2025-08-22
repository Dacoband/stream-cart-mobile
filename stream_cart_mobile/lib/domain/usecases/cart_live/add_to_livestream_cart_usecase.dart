import '../../../core/services/livestream_cart_service.dart';

class AddToLivestreamCartUsecase {
  final LivestreamCartService cartService;
  AddToLivestreamCartUsecase(this.cartService);

  Future<void> call({
    required String livestreamId,
    required String livestreamProductId,
    required int quantity,
  }) async {
    await cartService.addToCart(livestreamId, livestreamProductId, quantity);
  }
}
