import 'package:dartz/dartz.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import '../../core/error/failures.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    return await repository.getCartItems();
  }
}
