import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';

abstract class HomeRemoteDataSource {
  Future<CategoryResponseModel> getCategories();
  Future<ProductResponseModel> getProducts({int page = 1, int limit = 20});
  Future<ProductResponseModel> searchProducts({required String query, int page = 1, int limit = 20});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<CategoryResponseModel> getCategories() async {
    final url = ApiUrlHelper.getFullUrl(ApiConstants.categoriesEndpoint);
    final response = await dio.get(url);
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getProducts({int page = 1, int limit = 20}) async {
    final url = ApiUrlHelper.getFullUrl(ApiConstants.productsEndpoint);
    final response = await dio.get(
      url,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return ProductResponseModel.fromJson(response.data);
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
}
