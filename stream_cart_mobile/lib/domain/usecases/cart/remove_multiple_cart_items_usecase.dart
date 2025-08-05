import 'package:dartz/dartz.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class RemoveMultipleCartItemsParams {
  final List<String> cartItemIds;

  RemoveMultipleCartItemsParams({required this.cartItemIds});
}

class RemoveMultipleCartItemsUseCase {
  final CartRepository repository;

  RemoveMultipleCartItemsUseCase(this.repository);

  Future<Either<Failure, void>> call(RemoveMultipleCartItemsParams params) async {
    return await repository.removeMultipleCartItems(params.cartItemIds);
  }
}