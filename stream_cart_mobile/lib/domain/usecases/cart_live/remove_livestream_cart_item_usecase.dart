import '../../../core/services/livestream_cart_service.dart';

class RemoveLivestreamCartItemUsecase {
  final LivestreamCartService cartService;
  RemoveLivestreamCartItemUsecase(this.cartService);

  Future<void> call({
    required String cartItemId,
  }) async {
  await cartService.removeItem(cartItemId);
  }
}
