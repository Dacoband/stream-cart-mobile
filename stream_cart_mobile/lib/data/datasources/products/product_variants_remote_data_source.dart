import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';
import '../models/product_variants_model.dart';

abstract class ProductVariantsRemoteDataSource {
  Future<List<ProductVariantsModel>> getProductVariants();
  Future<ProductVariantsModel> getProductVariantById(String id);
  Future<List<ProductVariantsModel>> getProductVariantsByProductId(String productId);
  Future<ProductVariantsModel> updateProductVariantPrice(String id, double price);
  Future<ProductVariantsModel> updateProductVariantStock(String id, int stock);
}

class ProductVariantsRemoteDataSourceImpl implements ProductVariantsRemoteDataSource {
  final Dio dio;

  ProductVariantsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductVariantsModel>> getProductVariants() async {
    try {
      final response = await dio.get(
        ApiUrlHelper.getEndpoint(ApiConstants.productVariantsEndpoint),
      );

      if (response.statusCode == ApiConstants.successCode) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data.map((json) => ProductVariantsModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to get product variants: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ProductVariantsModel> getProductVariantById(String id) async {
    try {
      final response = await dio.get(
        ApiUrlHelper.getEndpoint(ApiConstants.productVariantDetailEndpoint.replaceAll('{id}', id)),
      );

      if (response.statusCode == ApiConstants.successCode) {
        final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
        return ProductVariantsModel.fromJson(data);
      } else {
        throw Exception('Failed to get product variant: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<ProductVariantsModel>> getProductVariantsByProductId(String productId) async {
    try {
      final response = await dio.get(
        ApiUrlHelper.getEndpoint(ApiConstants.productVariantByProductEndpoint.replaceAll('{productId}', productId)),
      );

      if (response.statusCode == ApiConstants.successCode) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data.map((json) => ProductVariantsModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to get product variants by product ID: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ProductVariantsModel> updateProductVariantPrice(String id, double price) async {
    try {
      final response = await dio.patch(
        ApiUrlHelper.getEndpoint(ApiConstants.productVariantsPriceEndpoint.replaceAll('{id}', id)),
        data: {'price': price},
      );

      if (response.statusCode == ApiConstants.successCode) {
        final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
        return ProductVariantsModel.fromJson(data);
      } else {
        throw Exception('Failed to update product variant price: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ProductVariantsModel> updateProductVariantStock(String id, int stock) async {
    try {
      final response = await dio.patch(
        ApiUrlHelper.getEndpoint(ApiConstants.productVariantsStockEndpoint.replaceAll('{id}', id)),
        data: {'stock': stock},
      );

      if (response.statusCode == ApiConstants.successCode) {
        final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
        return ProductVariantsModel.fromJson(data);
      } else {
        throw Exception('Failed to update product variant stock: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}