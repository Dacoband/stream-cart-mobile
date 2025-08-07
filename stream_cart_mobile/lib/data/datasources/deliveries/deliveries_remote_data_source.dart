import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/delivery/preview_deliveries_model.dart';
import '../../models/delivery/preview_deliveries_response_model.dart';

abstract class DeliveriesRemoteDataSource {
  Future<PreviewDeliveriesResponseModel> previewOrder(
    PreviewDeliveriesModel request,
  );
}

class DeliveriesRemoteDataSourceImpl implements DeliveriesRemoteDataSource {
  final Dio _dioClient;

  DeliveriesRemoteDataSourceImpl({required Dio dioClient}) : _dioClient = dioClient;

  @override
  Future<PreviewDeliveriesResponseModel> previewOrder(
    PreviewDeliveriesModel request,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.deliveryEndpoint,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;
        return PreviewDeliveriesResponseModel.fromJson(payload);
      }

      throw Exception('Unexpected response format');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to preview order: $e');
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
        final message = _extractMessage(e.response?.data) ?? 'Request failed';
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Network error: ${e.message}');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['detail']?.toString();
    }
    return null;
  }
}