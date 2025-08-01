import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/constants/api_constants.dart';
import 'flash_sale_remote_data_source.dart';
import '../../models/flash-sale/flash_sale_model.dart';
import '../../models/products/product_model.dart';

class FlashSaleRemoteDataSourceImpl implements FlashSaleRemoteDataSource {
  final Dio dio;

  FlashSaleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<FlashSaleModel>> getFlashSales() async {
    try {
      final response = await dio.get('https://brightpa.me${ApiConstants.flashSalesEndpoint}');
      
      if (response.statusCode == 200) {
        final jsonData = response.data;
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> flashSalesJson = jsonData['data'];
          return flashSalesJson
              .map((json) => FlashSaleModel.fromJson(json))
              .where((flashSale) => flashSale.isCurrentlyActive) // Only active flash sales
              .toList();
        } else {
          throw ServerException(jsonData['message'] ?? 'Failed to load flash sales');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ProductModel> getFlashSaleProduct(String productId) async {
    try {
      final response = await dio.get('https://brightpa.me/api/products/$productId');
      
      if (response.statusCode == 200) {
        final jsonData = response.data;
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          return ProductModel.fromJson(jsonData['data']);
        } else {
          throw ServerException(jsonData['message'] ?? 'Failed to load product');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<ProductModel>> getFlashSaleProducts(List<String> productIds) async {
    final List<ProductModel> products = [];
    
    // Fetch products concurrently for better performance
    final futures = productIds.map((id) => getFlashSaleProduct(id));
    
    try {
      final results = await Future.wait(futures);
      products.addAll(results);
      return products;
    } catch (e) {
      // If any product fails, return the ones that succeeded
      for (final id in productIds) {
        try {
          final product = await getFlashSaleProduct(id);
          products.add(product);
        } catch (e) {
          print('Failed to load product $id: $e');
          // Continue with other products
        }
      }
      return products;
    }
  }
}
