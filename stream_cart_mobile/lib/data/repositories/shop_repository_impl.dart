import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/shop.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_data_source.dart';
import '../models/shop_model.dart';

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
      print('🏪 Repository: Getting shops with params');

      final shopResponse = await remoteDataSource.getShops(
        pageNumber: pageNumber,
        pageSize: pageSize,
        status: status,
        approvalStatus: approvalStatus,
        searchTerm: searchTerm,
        sortBy: sortBy,
        ascending: ascending,
      );

      print('✅ Repository: Successfully fetched ${shopResponse.items.length} shops');
      return Right(shopResponse);
    } catch (e) {
      print('❌ Repository: Error fetching shops: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Shop>> getShopById(String shopId) async {
    try {
      print('🏪 Repository: Getting shop details for ID: $shopId');

      final shopModel = await remoteDataSource.getShopById(shopId);
      final shop = shopModel.toEntity();

      print('✅ Repository: Successfully fetched shop: ${shop.shopName}');
      return Right(shop);
    } catch (e) {
      print('❌ Repository: Error fetching shop details: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByShop(String shopId) async {
    try {
      print('🛍️ Repository: Getting products for shop ID: $shopId');

      final productResponse = await remoteDataSource.getProductsByShop(shopId);
      print('🛍️ [DEBUG] ShopRepositoryImpl - productResponse.data: ${productResponse.data}');
      
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

      print('✅ [DEBUG] Repository: Successfully fetched ${products.length} products for shop');
      print('🛍️ [DEBUG] ShopRepositoryImpl - products: $products');
      return Right(products);
    } catch (e) {
      print('❌ Repository: Error fetching shop products: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
