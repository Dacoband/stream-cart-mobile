import 'package:dio/dio.dart';
import '../models/search_response_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResponseModel> searchProducts({
    required String searchTerm,
    int? pageNumber,
    int? pageSize,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? sortBy,
    bool? inStockOnly,
    int? minRating,
    bool? onSaleOnly,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<SearchResponseModel> searchProducts({
    required String searchTerm,
    int? pageNumber,
    int? pageSize,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? sortBy,
    bool? inStockOnly,
    int? minRating,
    bool? onSaleOnly,
  }) async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.searchProductsEndpoint);
      print('🔍 DataSource: Calling search API: $endpoint');
      print('🔍 DataSource: Search term: "$searchTerm"');
      
      // Prepare query parameters
      final Map<String, dynamic> queryParams = {
        'SearchTerm': searchTerm,
      };

      // Add optional parameters if provided
      if (pageNumber != null) queryParams['PageNumber'] = pageNumber;
      if (pageSize != null) queryParams['PageSize'] = pageSize;
      if (categoryId != null) queryParams['CategoryId'] = categoryId;
      if (minPrice != null) queryParams['MinPrice'] = minPrice;
      if (maxPrice != null) queryParams['MaxPrice'] = maxPrice;
      if (shopId != null) queryParams['ShopId'] = shopId;
      if (sortBy != null) queryParams['SortBy'] = sortBy;
      if (inStockOnly != null) queryParams['InStockOnly'] = inStockOnly;
      if (minRating != null) queryParams['MinRating'] = minRating;
      if (onSaleOnly != null) queryParams['OnSaleOnly'] = onSaleOnly;

      print('🔍 DataSource: Query params: $queryParams');
      print('🔍 DataSource: Final endpoint will be: $endpoint with params: $queryParams');

      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      print('🔍 DataSource: Search response status: ${response.statusCode}');
      print('🔍 DataSource: Search response: ${response.data}');

      if (response.statusCode == 200) {
        final searchResponse = SearchResponseModel.fromJson(response.data);
        print('✅ DataSource: Parsed search response - success: ${searchResponse.success}, results: ${searchResponse.data.totalResults}');
        return searchResponse;
      } else {
        throw Exception('Search API returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('🚫 DataSource: DioException in searchProducts: ${e.message}');
      print('🚫 DataSource: Response data: ${e.response?.data}');
      
      if (e.response?.statusCode == 404) {
        // Return empty search result for 404
        return SearchResponseModel.fromJson({
          'success': false,
          'message': 'Không tìm thấy sản phẩm nào',
          'data': {
            'products': {
              'currentPage': 1,
              'pageSize': pageSize ?? 20,
              'totalCount': 0,
              'totalPages': 0,
              'hasPrevious': false,
              'hasNext': false,
              'items': []
            },
            'totalResults': 0,
            'searchTerm': searchTerm,
            'searchTimeMs': 0.0,
            'suggestedKeywords': [],
            'appliedFilters': {
              'categoryId': categoryId,
              'minPrice': minPrice,
              'maxPrice': maxPrice,
              'shopId': shopId,
              'sortBy': sortBy ?? 'relevance',
              'inStockOnly': inStockOnly ?? false,
              'minRating': minRating,
              'onSaleOnly': onSaleOnly ?? false,
            }
          },
          'errors': ['Không tìm thấy sản phẩm nào']
        });
      }
      rethrow;
    } catch (e) {
      print('💥 DataSource: Unexpected error in searchProducts: $e');
      rethrow;
    }
  }
}
