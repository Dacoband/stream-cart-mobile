import 'package:dartz/dartz.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class GetPreviewOrderParams {
  final List<String> cartItemIds;

  GetPreviewOrderParams({
    required this.cartItemIds,
  });
}

class GetPreviewOrderUseCase {
  final CartRepository repository;

  GetPreviewOrderUseCase(this.repository);

  Future<Either<Failure, PreviewOrderDataEntity>> call(GetPreviewOrderParams params) async {
    return await repository.getPreviewOrder(params.cartItemIds);
  }
}