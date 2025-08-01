import 'package:dartz/dartz.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class AddToCartParams {
  final String productId;
  final String variantId;
  final int quantity;

  AddToCartParams({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });
}

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, CartResponseEntity>> call(AddToCartParams params) async {
    return await repository.addToCart(
      params.productId,
      params.variantId,
      params.quantity,
    );
  }
}
