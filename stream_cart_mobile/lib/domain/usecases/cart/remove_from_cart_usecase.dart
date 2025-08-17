import 'package:dartz/dartz.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

@Deprecated('Use RemoveCartItemUseCase instead')
class RemoveFromCartParams {
  final String productId;
  final String? variantId;

  RemoveFromCartParams({
    required this.productId,
    this.variantId,
  });
}

@Deprecated('Use RemoveCartItemUseCase instead')
class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(
      params.productId,
      params.variantId,
    );
  }
}