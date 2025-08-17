import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/api_url_helper.dart';
import '../../models/shop/shop_model.dart';
import '../../models/products/product_model.dart';

abstract class ShopRemoteDataSource {
  Future<ShopResponse> getShops({
    int pageNumber = 1,
    int pageSize = 10,
    String? status,
    String? approvalStatus,
    String? searchTerm,
    String? sortBy,
    bool ascending = true,
  });

  Future<ShopModel> getShopById(String shopId);

  Future<ProductResponseModel> getProductsByShop(String shopId);
  
  Future<int> getProductCountByShop(String shopId);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final Dio dio;

  ShopRemoteDataSourceImpl(this.dio);

  @override
  Future<ShopResponse> getShops({
    int pageNumber = 1,
    int pageSize = 10,
    String? status,
    String? approvalStatus,
    String? searchTerm,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'ascending': ascending,
      };

      if (status != null) queryParameters['status'] = status;
      if (approvalStatus != null) queryParameters['approvalStatus'] = approvalStatus;
      if (searchTerm != null) queryParameters['searchTerm'] = searchTerm;
      if (sortBy != null) queryParameters['sortBy'] = sortBy;
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.shopsEndpoint);
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return ShopResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch shops: ${e.message}');
    }
  }

  @override
  Future<ShopModel> getShopById(String shopId) async {
    try {
      final url = ApiConstants.shopDetailEndpoint.replaceAll('{id}', shopId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      return ShopModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch shop details: ${e.message}');
    }
  }

  @override
  Future<ProductResponseModel> getProductsByShop(String shopId) async {
    try {
      final url = ApiConstants.productsByShopEndpoint.replaceAll('{shopId}', shopId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(
        endpoint,
        queryParameters: {
          'activeOnly': true,
        },
      );
      return ProductResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch shop products: ${e.message}');
    }
  }

  @override
  Future<int> getProductCountByShop(String shopId) async {
    try {
      final url = ApiConstants.countProductsByShopEndpoint.replaceAll('{shopId}', shopId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(
        endpoint,
        queryParameters: {
          'activeOnly': true,
        },
      );
      return response.data['data'] as int;
    } on DioException catch (e) {
      throw Exception('Failed to fetch shop product count: ${e.message}');
    }
  }
}
