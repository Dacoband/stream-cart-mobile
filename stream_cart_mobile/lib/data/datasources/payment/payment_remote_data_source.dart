import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/payment/payment_model.dart';

abstract class PaymentRemoteDataSource {
	Future<PaymentQrModel> generatePaymentQr(GeneratePaymentQrRequestModel request);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
	final Dio _dio;
	PaymentRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

	@override
	Future<PaymentQrModel> generatePaymentQr(GeneratePaymentQrRequestModel request) async {
		try {
			final response = await _dio.post(
				ApiConstants.paymentEndpoint,
				data: request.toJson(),
			);
			final raw = response.data;
			String? qrCodeValue;
			// 1. Direct map JSON
			if (raw is Map<String, dynamic>) {
				qrCodeValue = raw['qrCode'] as String?;
			}
			// 2. Plain string that might itself be JSON or already a URL
			else if (raw is String) {
				final trimmed = raw.trim();
				if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
					try {
						final decoded = json.decode(trimmed);
						if (decoded is Map<String, dynamic>) {
							qrCodeValue = decoded['qrCode'] as String?;
						}
					} catch (_) {
						// fall back below
					}
				}
				qrCodeValue ??= trimmed; // treat as already the url
			}

			if (qrCodeValue == null || qrCodeValue.isEmpty) {
				throw Exception('Không nhận được qrCode trong phản hồi');
			}
			// Some responses have a pipe-delimited payload: <url>|<encodedExtra>
			final urlPart = qrCodeValue.split('|').first.trim();
			if (urlPart.isEmpty) {
				throw Exception('Định dạng qrCode không hợp lệ');
			}
			// Remove any embedded whitespace/newlines that might break Image.network
			final cleanedUrl = urlPart.replaceAll(RegExp(r'\s+'), '');
			// Debug log (can be removed later)
			// ignore: avoid_print
			print('Payment QR URL: $cleanedUrl');
			return PaymentQrModel(qrImageUrl: cleanedUrl);
		} on DioException catch (e) {
			throw _handleDioException(e);
		} catch (e) {
			throw Exception('Failed to generate payment QR: $e');
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
				final message = e.response?.data is Map && e.response?.data['message'] != null
						? e.response?.data['message']
						: 'Request failed';
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

