import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/flash_sale_repository.dart';

class GetFlashSaleProductsUseCase {
  final FlashSaleRepository repository;

  GetFlashSaleProductsUseCase({required this.repository});

  Future<Either<Failure, List<ProductEntity>>> call(List<String> productIds) async {
    return await repository.getFlashSaleProducts(productIds);
  }
}
