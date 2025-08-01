import 'package:dartz/dartz.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}
