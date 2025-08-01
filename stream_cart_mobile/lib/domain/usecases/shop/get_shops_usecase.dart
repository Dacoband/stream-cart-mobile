import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/shop/shop.dart';
import '../../entities/products/product_entity.dart';
import '../../repositories/shop_repository.dart';
import '../../../data/models/shop/shop_model.dart';

class GetShopsUseCase {
  final ShopRepository repository;

  GetShopsUseCase(this.repository);

  Future<Either<Failure, ShopResponse>> call(GetShopsParams params) async {
    return await repository.getShops(
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      status: params.status,
      approvalStatus: params.approvalStatus,
      searchTerm: params.searchTerm,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}

class GetShopByIdUseCase {
  final ShopRepository repository;

  GetShopByIdUseCase(this.repository);

  Future<Either<Failure, Shop>> call(String shopId) async {
    return await repository.getShopById(shopId);
  }
}

class GetProductsByShopUseCase {
  final ShopRepository repository;

  GetProductsByShopUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String shopId) async {
    return await repository.getProductsByShop(shopId);
  }
}

class GetShopsParams {
  final int pageNumber;
  final int pageSize;
  final String? status;
  final String? approvalStatus;
  final String? searchTerm;
  final String? sortBy;
  final bool ascending;

  GetShopsParams({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.status,
    this.approvalStatus,
    this.searchTerm,
    this.sortBy,
    this.ascending = true,
  });
}
