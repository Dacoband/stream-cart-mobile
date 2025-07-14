import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_image_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';

abstract class HomeRemoteDataSource {
  Future<CategoryResponseModel> getCategories();
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
    final url = ApiUrlHelper.getFullUrl(ApiConstants.categoriesEndpoint);
    print('🌐 DataSource: Calling categories API: $url');
    final response = await dio.get(url);
    print('📦 DataSource: Categories raw response: ${response.data}');
    final result = CategoryResponseModel.fromJson(response.data);
    print('✅ DataSource: Parsed categories - success: ${result.success}, count: ${result.data.length}');
    return result;
  }

  @override
  Future<ProductResponseModel> getProducts({int page = 1, int limit = 20}) async {
    final url = ApiUrlHelper.getFullUrl(ApiConstants.productsEndpoint);
    print('🌐 DataSource: Calling products API: $url (page: $page, limit: $limit)');
    final response = await dio.get(
      url,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    print('🛍️ DataSource: Products raw response: ${response.data}');
    final result = ProductResponseModel.fromJson(response.data);
    print('✅ DataSource: Parsed products - success: ${result.success}, count: ${result.data.length}');
    return result;
  }

  @override
  Future<ProductResponseModel> searchProducts({required String query, int page = 1, int limit = 20}) async {
    final url = ApiUrlHelper.getFullUrl(ApiConstants.searchProductsEndpoint);
    final response = await dio.get(
      url,
      queryParameters: {
        'query': query,
        'page': page,
        'limit': limit,
      },
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductDetailModel> getProductDetail(String productId) async {
    try {
      print('🛍️ DataSource: Calling product detail API for ID: $productId');
      final url = ApiConstants.productDetailEndpoint.replaceAll('{id}', productId);
      print('🛍️ DataSource: Product detail URL: $url');
      
      final response = await dio.get(url);
      print('🛍️ DataSource: Product detail response: ${response.data}');
      
      // Parse response - API trả về có wrapper {success, message, data, errors}
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        print('✅ DataSource: Parsed product detail successfully');
        return ProductDetailModel.fromJson(responseData['data']);
      } else {
        print('❌ DataSource: Invalid product detail response format');
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
      print('🖼️ DataSource: Calling product images API: $url');
      
      final response = await dio.get(url);
      print('📸 DataSource: Product images response: ${response.data}');
      
      // Parse response - API trả về có wrapper {success, message, data, errors}
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> imagesData = responseData['data'] as List<dynamic>;
        final images = imagesData.map((json) => ProductImageModel.fromJson(json)).toList();
        
        // Sắp xếp theo displayOrder
        images.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        
        print('✅ DataSource: Parsed ${images.length} product images successfully');
        return images;
      } else {
        print('❌ DataSource: Invalid product images response format');
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
      print('🖼️ DataSource: Calling all product images API: $url');
      
      final response = await dio.get(url);
      print('📸 DataSource: All product images response: ${response.data}');
      
      // Parse response - API trả về có wrapper {success, message, data, errors}
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> imagesData = responseData['data'] as List<dynamic>;
        final images = imagesData.map((json) => ProductImageModel.fromJson(json)).toList();
        
        print('✅ DataSource: Parsed ${images.length} product images successfully');
        return images;
      } else {
        print('❌ DataSource: Invalid all product images response format');
        throw Exception('Invalid response format or failed response');
      }
    } catch (e) {
      print('❌ DataSource: Error getting all product images: $e');
      rethrow;
    }
  }
}
