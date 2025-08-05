import 'package:dartz/dartz.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class UpdateCartItemParams {
  final String cartItemId;
  final int quantity;

  UpdateCartItemParams({
    required this.cartItemId,
    required this.quantity,
  });
}

class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  Future<Either<Failure, CartResponseEntity>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(
      params.cartItemId,
      params.quantity,
    );
  }
}