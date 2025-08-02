import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/api_url_helper.dart';
import '../../../domain/entities/products/product_attribute_entity.dart';
import '../../models/products/product_attribute_model.dart';

abstract class ProductAttributeRemoteDataSource {
  Future<List<ProductAttributeEntity>> getAllProductAttributes();
  Future<ProductAttributeEntity> getProductAttributeById(String id);
  Future<List<ProductAttributeEntity>> getProductAttributesByProduct(String productId);
  Future<List<ProductAttributeEntity>> getProductAttributesWithValues();
}

class ProductAttributeRemoteDataSourceImpl implements ProductAttributeRemoteDataSource {
  final Dio dio;

  ProductAttributeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductAttributeEntity>> getAllProductAttributes() async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.productAttributesEndpoint);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> attributesData = responseData['data'] as List<dynamic>;
        final models = attributesData.map((json) => ProductAttributeModel.fromJson(json)).toList();
        final entities = models.map((model) {
          return ProductAttributeEntity(
            id: model.id,
            name: model.name,
            createdAt: model.createdAt,
            createdBy: model.createdBy,
            lastModifiedAt: model.lastModifiedAt,
            lastModifiedBy: model.lastModifiedBy,
          );
        }).toList();
        return entities;
      } else {
        print('[DataSource] No product attributes found');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting product attributes: $e');
      throw Exception('Failed to get product attributes: $e');
    }
  }

  @override
  Future<ProductAttributeEntity> getProductAttributeById(String id) async {
    try {
      final url = ApiConstants.productAttributeDetailEndpoint.replaceAll('{id}', id);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = ProductAttributeModel.fromJson(responseData['data']);
        return ProductAttributeEntity(
          id: model.id,
          name: model.name,
          createdAt: model.createdAt,
          createdBy: model.createdBy,
          lastModifiedAt: model.lastModifiedAt,
          lastModifiedBy: model.lastModifiedBy,
        );
      } else {
        throw Exception('Product attribute not found');
      }
    } catch (e) {
      print('[DataSource] Error getting product attribute by ID: $e');
      throw Exception('Failed to get product attribute: $e');
    }
  }

  @override
  Future<List<ProductAttributeEntity>> getProductAttributesByProduct(String productId) async {
    try {
      final url = ApiConstants.productAttributesByProductEndpoint.replaceAll('{productId}', productId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> attributesData = responseData['data'] as List<dynamic>;
        final models = attributesData.map((json) => ProductAttributeModel.fromJson(json)).toList();
        final entities = models.map((model) {
          return ProductAttributeEntity(
            id: model.id,
            name: model.name,
            createdAt: model.createdAt,
            createdBy: model.createdBy,
            lastModifiedAt: model.lastModifiedAt,
            lastModifiedBy: model.lastModifiedBy,
          );
        }).toList();
        return entities;
      } else {
        print('[DataSource] No product attributes found for product: $productId');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting product attributes by product: $e');
      throw Exception('Failed to get product attributes: $e');
    }
  }

  @override
  Future<List<ProductAttributeEntity>> getProductAttributesWithValues(String Id) async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.productAttributesValuesEndpoint);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> attributesData = responseData['data'] as List<dynamic>;
        final models = attributesData.map((json) => ProductAttributeModel.fromJson(json)).toList();
        final entities = models.map((model) {
          return ProductAttributeEntity(
            id: model.id,
            name: model.name,
            createdAt: model.createdAt,
            createdBy: model.createdBy,
            lastModifiedAt: model.lastModifiedAt,
            lastModifiedBy: model.lastModifiedBy,
          );
        }).toList();
        return entities;
      } else {
        print('[DataSource] No product attributes with values found');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting product attributes with values: $e');
      throw Exception('Failed to get product attributes with values: $e');
    }
  }
}