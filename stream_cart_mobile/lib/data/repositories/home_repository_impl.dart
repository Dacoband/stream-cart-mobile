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
      final response = await remoteDataSource.getCategories();
      if (response.success) {
        final categories = response.data.map((model) => model.toEntity()).toList();
        return Right(categories);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
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
  Future<Either<Failure, CategoryEntity>> getCategoryDetail(String categoryId) async {
    try {
      final response = await remoteDataSource.getCategoryDetail(categoryId);
      if (response.success) {
        final category = response.data.toEntity();
        return Right(category);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Category not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String categoryId) async {
    try {
      final response = await remoteDataSource.getProductsByCategory(categoryId);
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        return Right(products);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('No products found for this category'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int limit = 20}) async {
    try {
      final response = await remoteDataSource.getProducts(page: page, limit: limit);
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        return Right(products);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Products not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({required String query, int page = 1, int limit = 20}) async {
    try {
      final response = await remoteDataSource.searchProducts(query: query, page: page, limit: limit);
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        return Right(products);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('No products found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProductDetailEntity>> getProductDetail(String productId) async {
    try {
      final productDetailModel = await remoteDataSource.getProductDetail(productId);
      final entity = productDetailModel.toEntity();    
      return Right(entity);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Product not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get product detail: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductImageEntity>>> getProductImages(String productId) async {
    try {
      final images = await remoteDataSource.getProductImages(productId);    
      final imageEntities = images.map((model) => model.toEntity()).toList();
      return Right(imageEntities);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Product images not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get product images: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getProductPrimaryImages(List<String> productIds) async {
    try {
      // Create a map of productId -> primaryImageUrl
      final Map<String, String> primaryImages = {};      
      // Load images for each product individually using specific API endpoint
      for (final productId in productIds) {
        try {
          final productImages = await remoteDataSource.getProductImages(productId);  
          if (productImages.isNotEmpty) {
            // Sort by displayOrder and find primary image
            productImages.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
            
            // Try to find primary image first, otherwise use first image
            final primaryImage = productImages.firstWhere(
              (img) => img.isPrimary,
              orElse: () => productImages.first,
            );
            
            primaryImages[productId] = primaryImage.imageUrl;
          } else {
            print('⚠️ Repository: No images found for product: $productId');
          }
        } catch (e) {
          return Left(ServerFailure('Failed to get primary image for product $productId'));
        }
      }
      return Right(primaryImages);
    } catch (e) {
      return Left(ServerFailure('Failed to get product primary images: $e'));
    }
  }
}
