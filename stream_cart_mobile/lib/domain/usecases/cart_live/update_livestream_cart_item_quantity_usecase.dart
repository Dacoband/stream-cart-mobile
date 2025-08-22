import '../../../core/services/livestream_cart_service.dart';

class UpdateLivestreamCartItemQuantityUsecase {
  final LivestreamCartService cartService;
  UpdateLivestreamCartItemQuantityUsecase(this.cartService);

  Future<void> call({
    required String cartItemId,
    required int newQuantity,
  }) async {
    await cartService.updateItemQuantity(cartItemId, newQuantity);
  }
}
