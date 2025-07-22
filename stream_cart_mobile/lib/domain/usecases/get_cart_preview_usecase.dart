import 'package:dartz/dartz.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import '../../core/error/failures.dart';

class GetCartPreviewUseCase {
  final CartRepository repository;

  GetCartPreviewUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call() async {
    return await repository.getCartPreview();
  }
}
