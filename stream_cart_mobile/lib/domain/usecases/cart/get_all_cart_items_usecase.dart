import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';

class GetAllCartItemsUseCase {
  final CartRepository repository;

  GetAllCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    final result = await repository.getCartItems();
    
    return result.fold(
      (failure) => Left(failure),
      (cartSummary) {
        List<CartItemEntity> allItems = [];
        for (var shop in cartSummary.listCartItem) {
          allItems.addAll(shop.products);
        }
        return Right(allItems);
      },
    );
  }
}
