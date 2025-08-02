import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/api_url_helper.dart';
import '../../../domain/entities/products/attribute_value_entity.dart';
import '../../models/products/attribute_value_model.dart';

abstract class AttributeValueRemoteDataSource {
  Future<List<AttributeValueEntity>> getAllAttributeValues();
  Future<AttributeValueEntity> getAttributeValueById(String id);
  Future<List<AttributeValueEntity>> getAttributeValuesByAttribute(String attributeId);
}

class AttributeValueRemoteDataSourceImpl implements AttributeValueRemoteDataSource {
  final Dio dio;

  AttributeValueRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AttributeValueEntity>> getAllAttributeValues() async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.attributeValuesEndpoint);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> valuesData = responseData['data'] as List<dynamic>;
        final models = valuesData.map((json) => AttributeValueModel.fromJson(json)).toList();
        final entities = models.map((model) {
          return AttributeValueEntity(
            id: model.id,
            attributeId: model.attributeId,
            valueName: model.valueName,
            createdAt: model.createdAt,
            createdBy: model.createdBy,
            lastModifiedAt: model.lastModifiedAt,
            lastModifiedBy: model.lastModifiedBy,
          );
        }).toList();
        return entities;
      } else {
        print('[DataSource] No attribute values found');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting attribute values: $e');
      throw Exception('Failed to get attribute values: $e');
    }
  }

  @override
  Future<AttributeValueEntity> getAttributeValueById(String id) async {
    try {
      final url = ApiConstants.attributeValueDetailEndpoint.replaceAll('{id}', id);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = AttributeValueModel.fromJson(responseData['data']);
        return AttributeValueEntity(
          id: model.id,
          attributeId: model.attributeId,
          valueName: model.valueName,
          createdAt: model.createdAt,
          createdBy: model.createdBy,
          lastModifiedAt: model.lastModifiedAt,
          lastModifiedBy: model.lastModifiedBy,
        );
      } else {
        throw Exception('Attribute value not found');
      }
    } catch (e) {
      print('[DataSource] Error getting attribute value by ID: $e');
      throw Exception('Failed to get attribute value: $e');
    }
  }

  @override
  Future<List<AttributeValueEntity>> getAttributeValuesByAttribute(String attributeId) async {
    try {
      final url = ApiConstants.attributeValuesByAttributeEndpoint.replaceAll('{attributeId}', attributeId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> valuesData = responseData['data'] as List<dynamic>;
        final models = valuesData.map((json) => AttributeValueModel.fromJson(json)).toList();
        final entities = models.map((model) {
          return AttributeValueEntity(
            id: model.id,
            attributeId: model.attributeId,
            valueName: model.valueName,
            createdAt: model.createdAt,
            createdBy: model.createdBy,
            lastModifiedAt: model.lastModifiedAt,
            lastModifiedBy: model.lastModifiedBy,
          );
        }).toList();
        return entities;
      } else {
        print('[DataSource] No attribute values found for attribute: $attributeId');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting attribute values by attribute: $e');
      throw Exception('Failed to get attribute values: $e');
    }
  }
}