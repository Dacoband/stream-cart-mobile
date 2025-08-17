import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/shop/shop.dart';
import '../../domain/entities/products/product_entity.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop/shop_remote_data_source.dart';
import '../models/shop/shop_model.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ShopResponse>> getShops({
    int pageNumber = 1,
    int pageSize = 10,
    String? status,
    String? approvalStatus,
    String? searchTerm,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {

      final shopResponse = await remoteDataSource.getShops(
        pageNumber: pageNumber,
        pageSize: pageSize,
        status: status,
        approvalStatus: approvalStatus,
        searchTerm: searchTerm,
        sortBy: sortBy,
        ascending: ascending,
      );
      return Right(shopResponse);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Shop>> getShopById(String shopId) async {
    try {
      final shopModel = await remoteDataSource.getShopById(shopId);
      final shop = shopModel.toEntity();
      return Right(shop);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByShop(String shopId) async {
    try {
      final productResponse = await remoteDataSource.getProductsByShop(shopId);   
      // Convert ProductModel list to ProductEntity list
      final products = productResponse.data.map((productModel) => 
        ProductEntity(
          id: productModel.id,
          productName: productModel.productName,
          description: productModel.description,
          sku: productModel.sku,
          categoryId: productModel.categoryId,
          basePrice: productModel.basePrice,
          discountPrice: productModel.discountPrice,
          finalPrice: productModel.finalPrice,
          stockQuantity: productModel.stockQuantity,
          isActive: productModel.isActive,
          weight: productModel.weight,
          length: productModel.length,
          width: productModel.width,
          height: productModel.height,
          hasVariant: productModel.hasVariant,
          quantitySold: productModel.quantitySold,
          shopId: productModel.shopId,
          createdAt: DateTime.tryParse(productModel.createdAt) ?? DateTime.now(),
          createdBy: productModel.createdBy,
          lastModifiedAt: productModel.lastModifiedAt != null 
              ? DateTime.tryParse(productModel.lastModifiedAt!)
              : null,
          lastModifiedBy: productModel.lastModifiedBy,
          hasPrimaryImage: productModel.hasPrimaryImage,
          primaryImageUrl: productModel.primaryImageUrl,
        )
      ).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getProductCountByShop(String shopId) async {
    try {
      final count = await remoteDataSource.getProductCountByShop(shopId);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
