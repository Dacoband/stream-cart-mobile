import 'package:dartz/dartz.dart';
import '../entities/cart/cart_entity.dart';
import '../../core/error/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, CartResponseEntity>> addToCart(
    String productId,
    String variantId,
    int quantity,
  );
  
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  
  Future<Either<Failure, CartResponseEntity>> updateCartItem(
    String productId,
    String? variantId,
    int quantity,
  );
  
  Future<Either<Failure, void>> removeFromCart(
    String productId,
    String? variantId,
  );

  Future<Either<Failure, void>> removeCartItem(String cartItemId);
  
  Future<Either<Failure, void>> removeMultipleCartItems(List<String> cartItemIds);
  
  Future<Either<Failure, void>> clearCart();
  
  Future<Either<Failure, CartEntity>> getCartPreview();
  
  Future<Either<Failure, CartSummaryEntity>> getPreviewOrder(List<String> cartItemIds);
}
