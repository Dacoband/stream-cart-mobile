import 'package:dartz/dartz.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

@Deprecated('Use GetCartItemsUseCase instead')
class GetCartSummaryUseCase {
  final CartRepository repository;

  GetCartSummaryUseCase(this.repository);

  Future<Either<Failure, CartSummaryEntity>> call() async {
    return await repository.getCartSummary();
  }
}