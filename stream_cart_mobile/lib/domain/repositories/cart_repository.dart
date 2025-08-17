import 'package:dartz/dartz.dart';
import '../entities/cart/cart_entity.dart';
import '../../core/error/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, CartResponseEntity>> addToCart(
    String productId,
    String? variantId,
    int quantity,
  );
  
  Future<Either<Failure, CartDataEntity>> getCartItems();
  
  Future<Either<Failure, CartResponseEntity>> updateCartItem(
    String cartItemId,
    int quantity,
  );
  
  Future<Either<Failure, void>> removeCartItem(String cartItemId);
  
  Future<Either<Failure, void>> removeMultipleCartItems(List<String> cartItemIds);
  
  Future<Either<Failure, void>> clearCart();
  
  Future<Either<Failure, PreviewOrderDataEntity>> getPreviewOrder(List<String> cartItemIds);

  @Deprecated('Use getCartItems() instead')
  Future<Either<Failure, CartSummaryEntity>> getCartSummary();

  @Deprecated('Use removeCartItem() instead')
  Future<Either<Failure, void>> removeFromCart(
    String productId,
    String? variantId,
  );

  @Deprecated('Use getPreviewOrder() instead')
  Future<Either<Failure, CartEntity>> getCartPreview();
}