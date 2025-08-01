import 'package:dio/dio.dart';
import '../../../domain/entities/products/product_variants_entity.dart';
import '../../models/products/product_variants_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/api_url_helper.dart';

abstract class ProductVariantsRemoteDataSource {
  Future<List<ProductVariantEntity>> getProductVariantsByProductId(String productId); 
  Future<ProductVariantEntity> getProductVariantById(String variantId);
  Future<List<ProductVariantEntity>> getProductVariants();
  Future<ProductVariantEntity> updateProductVariantPrice(String id, double price);
  Future<ProductVariantEntity> updateProductVariantStock(String id, int stock);
}

class ProductVariantsRemoteDataSourceImpl implements ProductVariantsRemoteDataSource {
  final Dio dio;

  ProductVariantsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductVariantEntity>> getProductVariantsByProductId(String productId) async {
    try {
      final url = ApiConstants.productVariantByProductEndpoint.replaceAll('{productId}', productId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> variantsData = responseData['data'] as List<dynamic>;
        final models = variantsData.map((json) => ProductVariantsModel.fromJson(json)).toList();
        final entities = models.map((model) {
          return ProductVariantEntity(
            id: model.id,
            productId: model.productId,
            sku: model.sku,
            price: model.price,
            flashSalePrice: model.flashSalePrice,
            stock: model.stock,
            createdAt: model.createdAt,
            createdBy: model.createdBy,
            lastModifiedAt: model.lastModifiedAt,
            lastModifiedBy: model.lastModifiedBy,
          );
        }).toList();
        return entities;
      } else {
        print('[DataSource] No variants found for product: $productId');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting product variants: $e');
      throw Exception('Failed to get product variants: $e');
    }
  }

  @override
  Future<ProductVariantEntity> getProductVariantById(String variantId) async {
    try {
      final url = ApiConstants.productVariantDetailEndpoint.replaceAll('{variantId}', variantId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = ProductVariantsModel.fromJson(responseData['data']);
        return ProductVariantEntity(
          id: model.id,
          productId: model.productId,
          sku: model.sku,
          price: model.price,
          flashSalePrice: model.flashSalePrice,
          stock: model.stock,
          createdAt: model.createdAt,
          createdBy: model.createdBy,
          lastModifiedAt: model.lastModifiedAt,
          lastModifiedBy: model.lastModifiedBy,
        );
      } else {
        throw Exception('Product variant not found');
      }
    } catch (e) {
      print('[DataSource] Error getting variant by ID: $e');
      throw Exception('Failed to get product variant: $e');
    }
  }

  @override
  Future<List<ProductVariantEntity>> getProductVariants() async {
    // cho get all variants nếu cần
    throw UnimplementedError();
  }

  @override
  Future<ProductVariantEntity> updateProductVariantPrice(String id, double price) async {
    // cho update price nếu cần
    throw UnimplementedError();
  }

  @override
  Future<ProductVariantEntity> updateProductVariantStock(String id, int stock) async {
    // cho update stock nếu cần
    throw UnimplementedError();
  }
}