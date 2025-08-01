import 'package:dartz/dartz.dart';
import '../repositories/cart_repository.dart';
import '../../core/error/failures.dart';

class RemoveCartItemUseCase {
  final CartRepository repository;

  RemoveCartItemUseCase(this.repository);

  Future<Either<Failure, void>> call(String cartItemId) async {
    return await repository.removeCartItem(cartItemId);
  }
}
