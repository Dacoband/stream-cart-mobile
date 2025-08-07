import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/shop/shop.dart';
import '../entities/products/product_entity.dart';
import '../../data/models/shop/shop_model.dart';

abstract class ShopRepository {
  Future<Either<Failure, ShopResponse>> getShops({
    int pageNumber = 1,
    int pageSize = 10,
    String? status,
    String? approvalStatus,
    String? searchTerm,
    String? sortBy,
    bool ascending = true,
  });

  Future<Either<Failure, Shop>> getShopById(String shopId);

  Future<Either<Failure, List<ProductEntity>>> getProductsByShop(String shopId);
  
  Future<Either<Failure, int>> getProductCountByShop(String shopId);
}
