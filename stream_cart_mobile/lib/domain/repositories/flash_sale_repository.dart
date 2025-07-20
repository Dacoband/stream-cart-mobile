import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/flash_sale_entity.dart';
import '../entities/product_entity.dart';

abstract class FlashSaleRepository {
  Future<Either<Failure, List<FlashSaleEntity>>> getFlashSales();
  Future<Either<Failure, ProductEntity>> getFlashSaleProduct(String productId);
  Future<Either<Failure, List<ProductEntity>>> getFlashSaleProducts(List<String> productIds);
}
