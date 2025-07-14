import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/product_image_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../core/error/failures.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      print('🌐 Repository: Calling getCategories API...');
      final response = await remoteDataSource.getCategories();
      print('📦 Repository: Categories response - success: ${response.success}, data count: ${response.data.length}');
      
      if (response.success) {
        final categories = response.data.map((model) => model.toEntity()).toList();
        print('✅ Repository: Mapped ${categories.length} categories');
        return Right(categories);
      } else {
        print('❌ Repository: Categories API returned error: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getCategories: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Categories not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getCategories: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int limit = 20}) async {
    try {
      print('🌐 Repository: Calling getProducts API (page: $page, limit: $limit)...');
      final response = await remoteDataSource.getProducts(page: page, limit: limit);
      print('🛍️ Repository: Products response - success: ${response.success}, data count: ${response.data.length}');
      
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        print('✅ Repository: Mapped ${products.length} products');
        return Right(products);
      } else {
        print('❌ Repository: Products API returned error: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getProducts: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Products not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getProducts: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({required String query, int page = 1, int limit = 20}) async {
    try {
      print('🔍 Repository: Calling searchProducts API (query: $query, page: $page, limit: $limit)...');
      final response = await remoteDataSource.searchProducts(query: query, page: page, limit: limit);
      print('🔍 Repository: Search response - success: ${response.success}, data count: ${response.data.length}');
      
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        print('✅ Repository: Mapped ${products.length} search results');
        return Right(products);
      } else {
        print('❌ Repository: Search API returned error: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in searchProducts: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('No products found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in searchProducts: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProductDetailEntity>> getProductDetail(String productId) async {
    try {
      print('📦 Repository: Calling getProductDetail for ID: $productId...');
      final productDetailModel = await remoteDataSource.getProductDetail(productId);
      print('📦 Repository: Product detail response - success, product: ${productDetailModel.productName}');
      
      final entity = productDetailModel.toEntity();
      print('✅ Repository: Mapped product detail entity: ${entity.productName}');
      
      return Right(entity);
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getProductDetail: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Product not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getProductDetail: $e');
      return Left(ServerFailure('Failed to get product detail: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductImageEntity>>> getProductImages(String productId) async {
    try {
      print('🖼️ Repository: Calling getProductImages API for product: $productId');
      final images = await remoteDataSource.getProductImages(productId);
      
      final imageEntities = images.map((model) => model.toEntity()).toList();
      print('✅ Repository: Mapped ${imageEntities.length} product images');
      return Right(imageEntities);
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getProductImages: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Product images not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getProductImages: $e');
      return Left(ServerFailure('Failed to get product images: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getProductPrimaryImages(List<String> productIds) async {
    try {
      print('🖼️ Repository: Getting primary images for ${productIds.length} products');
      final allImages = await remoteDataSource.getAllProductImages();
      
      // Create a map of productId -> primaryImageUrl
      final Map<String, String> primaryImages = {};
      
      for (final productId in productIds) {
        // Filter images for this product
        final productImages = allImages.where((img) => img.productId == productId).toList();
        
        if (productImages.isNotEmpty) {
          // Sort by displayOrder and find primary image
          productImages.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
          
          // Try to find primary image first, otherwise use first image
          final primaryImage = productImages.firstWhere(
            (img) => img.isPrimary,
            orElse: () => productImages.first,
          );
          
          primaryImages[productId] = primaryImage.imageUrl;
        }
      }
      
      print('✅ Repository: Found ${primaryImages.length} primary images');
      return Right(primaryImages);
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getProductPrimaryImages: ${e.message}');
      return Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      print('💥 Repository: Unexpected error in getProductPrimaryImages: $e');
      return Left(ServerFailure('Failed to get primary images: ${e.toString()}'));
    }
  }
}
