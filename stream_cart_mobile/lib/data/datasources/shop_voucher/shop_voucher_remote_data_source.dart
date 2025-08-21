import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/shop_voucher/shop_voucher_model.dart';

abstract class ShopVoucherRemoteDataSource {
  Future<ShopVouchersResponseModel> getVouchers({
    required String shopId,
    bool? isActive,
    int? type,
    bool? isExpired,
    int pageNumber = 1,
    int pageSize = 10,
  });
  Future<ApplyShopVoucherResponseModel> applyVoucher({
    required String code,
    required ApplyShopVoucherRequestModel request,
  });
}

class ShopVoucherRemoteDataSourceImpl implements ShopVoucherRemoteDataSource {
  final Dio _dioClient;

  ShopVoucherRemoteDataSourceImpl({required Dio dioClient})
      : _dioClient = dioClient;

  @override
  Future<ShopVouchersResponseModel> getVouchers({
    required String shopId,
    bool? isActive,
    int? type,
    bool? isExpired,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (isActive != null) 'isActive': isActive,
        if (type != null) 'type': type,
        if (isExpired != null) 'isExpired': isExpired,
      };

      final response = await _dioClient.get(
        ApiConstants.getShopVouchersByShopIdEndpoint.replaceAll('{shopId}', shopId),
        queryParameters: queryParams,
      );

      return ShopVouchersResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get shop vouchers: $e');
    }
  }

  @override
  Future<ApplyShopVoucherResponseModel> applyVoucher({
    required String code,
    required ApplyShopVoucherRequestModel request,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.applyShopVoucherEndpoint.replaceAll('{code}', code),
        data: request.toJson(),
      );
      return ApplyShopVoucherResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to apply voucher: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Request failed';
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}