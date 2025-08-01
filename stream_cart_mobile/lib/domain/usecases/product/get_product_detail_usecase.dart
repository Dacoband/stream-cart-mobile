import 'package:dartz/dartz.dart';
import '../../entities/products/product_detail_entity.dart';
import '../../repositories/home_repository.dart';
import '../../../core/error/failures.dart';

class GetProductDetailUseCase {
  final HomeRepository repository;

  GetProductDetailUseCase(this.repository);

  Future<Either<Failure, ProductDetailEntity>> call(String productId) async {
    return await repository.getProductDetail(productId);
  }
}
