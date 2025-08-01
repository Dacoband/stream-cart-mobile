import 'package:dartz/dartz.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class UpdateCartItemParams {
  final String productId;
  final String? variantId;
  final int quantity;

  UpdateCartItemParams({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });
}

class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  Future<Either<Failure, CartResponseEntity>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(
      params.productId,
      params.variantId,
      params.quantity,
    );
  }
}
