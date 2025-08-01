import 'package:dartz/dartz.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class RemoveMultipleCartItemsUseCase {
  final CartRepository repository;

  RemoveMultipleCartItemsUseCase(this.repository);

  Future<Either<Failure, void>> call(List<String> cartItemIds) async {
    return await repository.removeMultipleCartItems(cartItemIds);
  }
}
