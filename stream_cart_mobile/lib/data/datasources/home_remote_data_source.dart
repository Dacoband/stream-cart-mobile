import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/category_detail_model.dart';
import '../models/product_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_image_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';

abstract class HomeRemoteDataSource {
  Future<CategoryResponseModel> getCategories();
  Future<CategoryDetailResponseModel> getCategoryDetail(String categoryId);
  Future<ProductResponseModel> getProductsByCategory(String categoryId);
  Future<ProductResponseModel> getProducts({int page = 1, int limit = 20});
  Future<ProductResponseModel> searchProducts({required String query, int page = 1, int limit = 20});
  Future<ProductDetailModel> getProductDetail(String productId);
  Future<List<ProductImageModel>> getProductImages(String productId);
  Future<List<ProductImageModel>> getAllProductImages();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<CategoryResponseModel> getCategories() async {
    final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.categoriesEndpoint);
    final response = await dio.get(endpoint);
    final result = CategoryResponseModel.fromJson(response.data);
    return result;
  }

  @override
  Future<CategoryDetailResponseModel> getCategoryDetail(String categoryId) async {
    try {
      final url = ApiConstants.categoryDetailEndpoint.replaceAll('{id}', categoryId);
      final endpoint = ApiUrlHelper.getEndpoint(url);      
      final response = await dio.get(endpoint); 
      final result = CategoryDetailResponseModel.fromJson(response.data);
      return result;
    } catch (e) {
      print('❌ DataSource: Error getting category detail: $e');
      rethrow;
    }
  }

  @override
  Future<ProductResponseModel> getProductsByCategory(String categoryId) async {
    try {
      final url = ApiConstants.productsByCategoryEndpoint.replaceAll('{id}', categoryId);
      final endpoint = ApiUrlHelper.getEndpoint(url); 
      final response = await dio.get(endpoint);    
      final result = ProductResponseModel.fromJson(response.data);
      return result;
    } catch (e) {
      print('❌ DataSource: Error getting products by category: $e');
      rethrow;
    }
  }

  @override
  Future<ProductResponseModel> getProducts({int page = 1, int limit = 20}) async {
    final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.productsEndpoint);
    final response = await dio.get(
      endpoint,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final result = ProductResponseModel.fromJson(response.data);
    return result;
  }

  @override
  Future<ProductResponseModel> searchProducts({required String query, int page = 1, int limit = 20}) async {
    final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.searchProductsEndpoint);
    final response = await dio.get(
      endpoint,
      queryParameters: {
        'SearchTerm': query,
        'PageNumber': page,
        'PageSize': limit,
      },
    );
    
    final searchResponse = response.data;
    if (searchResponse['success'] == true && searchResponse['data'] != null) {
      final data = searchResponse['data'];
      final products = data['products'];
      
      final productResponseData = {
        'success': true,
        'message': searchResponse['message'],
        'data': products['items'], 
        'errors': searchResponse['errors'] ?? []
      };
      
      return ProductResponseModel.fromJson(productResponseData);
    } else {
      return ProductResponseModel.fromJson({
        'success': false,
        'message': searchResponse['message'] ?? 'Search failed',
        'data': [],
        'errors': searchResponse['errors'] ?? ['Search failed']
      });
    }
  }

  @override
  Future<ProductDetailModel> getProductDetail(String productId) async {
    try {
      final url = ApiConstants.productDetailEndpoint.replaceAll('{id}', productId);
      final response = await dio.get(url);
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        return ProductDetailModel.fromJson(responseData['data']);
      } else {
        throw Exception('Invalid response format or failed response');
      }
    } catch (e) {
      print('❌ DataSource: Error getting product detail: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductImageModel>> getProductImages(String productId) async {
    try {
      final url = ApiUrlHelper.getFullUrl(
        ApiConstants.productImagesEndpoint.replaceAll('{productId}', productId),
      );    
      final response = await dio.get(url);    
      // Parse response - API trả về có wrapper {success, message, data, errors}
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> imagesData = responseData['data'] as List<dynamic>;
        final images = imagesData.map((json) => ProductImageModel.fromJson(json)).toList();      
        // Sắp xếp theo displayOrder
        images.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        
        return images;
      } else {
        throw Exception('Invalid response format or failed response');
      }
    } catch (e) {
      print('❌ DataSource: Error getting product images: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductImageModel>> getAllProductImages() async {
    try {
      final url = ApiUrlHelper.getFullUrl(ApiConstants.allProductImagesEndpoint);     
      final response = await dio.get(url);
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> imagesData = responseData['data'] as List<dynamic>;
        final images = imagesData.map((json) => ProductImageModel.fromJson(json)).toList();
        return images;
      } else {
        throw Exception('Invalid response format or failed response');
      }
    } catch (e) {
      print('❌ DataSource: Error getting all product images: $e');
      rethrow;
    }
  }
}
