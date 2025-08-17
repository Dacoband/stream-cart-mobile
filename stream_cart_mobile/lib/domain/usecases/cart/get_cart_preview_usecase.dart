import 'package:dartz/dartz.dart';
import '../../entities/cart/cart_entity.dart';
import '../../repositories/cart_repository.dart';
import '../../../core/error/failures.dart';

class GetCartPreviewParams {
  final List<String> cartItemIds;

  GetCartPreviewParams({required this.cartItemIds});
}

class GetCartPreviewUseCase {
  final CartRepository repository;

  GetCartPreviewUseCase(this.repository);

  Future<Either<Failure, PreviewOrderDataEntity>> call(GetCartPreviewParams params) async {
    return await repository.getPreviewOrder(params.cartItemIds);
  }
}