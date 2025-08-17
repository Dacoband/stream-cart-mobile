import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/order/create_order_request_model.dart';
import '../../models/order/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrdersByAccountId(
    String accountId, {
    int? status,
  });
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> getOrderByCode(String code);
  Future<List<OrderModel>> createMultipleOrders(CreateOrderRequestModel request);
  Future<OrderModel> cancelOrder(String id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio _dioClient;

  OrderRemoteDataSourceImpl({required Dio dioClient}) : _dioClient = dioClient;

  @override
  Future<List<OrderModel>> getOrdersByAccountId(
    String accountId, {
    int? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['Status'] = status;

      final response = await _dioClient.get(
        ApiConstants.orderAccountEndpoint.replaceAll('{accountId}', accountId),
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final List<dynamic> data = response.data['items'] ?? response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get orders by account: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.orderDetailEndpoint.replaceAll('{id}', id),
      );

      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get order by id: $e');
    }
  }

  @override
  Future<OrderModel> getOrderByCode(String code) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.orderCodeEndpoint.replaceAll('{id}', code),
      );

      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get order by code: $e');
    }
  }

  @override
  Future<List<OrderModel>> createMultipleOrders(CreateOrderRequestModel request) async {
    try {
      final requestData = request.toJson();   
      final response = await _dioClient.post(
        ApiConstants.ordersEndpoint,
        data: requestData,
      );

      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap.containsKey('data')) {
          final List<dynamic> data = responseMap['data'];
          return data.map((json) => OrderModel.fromJson(json)).toList();
        }
      }

      final List<dynamic> data = response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to create orders: $e');
    }
  }

  @override
  Future<OrderModel> cancelOrder(String id) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.orderCancelEndpoint.replaceAll('{id}', id),
      );

      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
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