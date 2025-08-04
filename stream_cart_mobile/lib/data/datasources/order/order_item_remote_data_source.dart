import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/order/add_order_item_request_model.dart';
import '../../models/order/order_item_model.dart';

abstract class OrderItemRemoteDataSource {
  Future<OrderItemModel> getOrderItemById(String id);
  Future<List<OrderItemModel>> getOrderItemsByOrderId(String orderId);
  Future<OrderItemModel> addOrderItem(String orderId, AddOrderItemRequestModel request);
  Future<void> deleteOrderItem(String id);
}

class OrderItemRemoteDataSourceImpl implements OrderItemRemoteDataSource {
  final Dio _dioClient;

  OrderItemRemoteDataSourceImpl({required Dio dioClient}) : _dioClient = dioClient;

  @override
  Future<OrderItemModel> getOrderItemById(String id) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.orderItemsEndpoint.replaceAll('{id}', id),
      );

      return OrderItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get order item by id: $e');
    }
  }

  @override
  Future<List<OrderItemModel>> getOrderItemsByOrderId(String orderId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.orderItemsByOrderEndpoint.replaceAll('{orderId}', orderId),
      );

      final List<dynamic> data = response.data;
      return data.map((json) => OrderItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to get order items by order id: $e');
    }
  }

  @override
  Future<OrderItemModel> addOrderItem(String orderId, AddOrderItemRequestModel request) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.createOrderItemByOrderEndpoint.replaceAll('{orderId}', orderId),
        data: request.toJson(),
      );

      return OrderItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to add order item: $e');
    }
  }

  @override
  Future<void> deleteOrderItem(String id) async {
    try {
      await _dioClient.delete(
        ApiConstants.orderItemsEndpoint.replaceAll('{id}', id),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to delete order item: $e');
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