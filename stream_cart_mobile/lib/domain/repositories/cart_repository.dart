import 'package:dartz/dartz.dart';
import '../entities/cart_entity.dart';
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
  
  Future<Either<Failure, void>> clearCart();
  
  Future<Either<Failure, CartEntity>> getCartPreview();
}
