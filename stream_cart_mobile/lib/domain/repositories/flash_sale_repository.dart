import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/flash-sale/flash_sale_entity.dart';
import '../entities/products/product_entity.dart';

abstract class FlashSaleRepository {
  Future<Either<Failure, List<FlashSaleEntity>>> getFlashSales();
  Future<Either<Failure, ProductEntity>> getFlashSaleProduct(String productId);
  Future<Either<Failure, List<ProductEntity>>> getFlashSaleProducts(List<String> productIds);
}
