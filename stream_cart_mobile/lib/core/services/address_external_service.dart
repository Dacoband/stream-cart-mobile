import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/models/address/address_model.dart';

class AddressExternalService {
  // Separate public client without auth/interceptors to avoid CORS preflight on web
  final Dio _publicDio = Dio(
    BaseOptions(
      // Do NOT set Content-Type for GET to keep it a simple request
      headers: const {
        'Accept': 'application/json, text/plain, */*',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      followRedirects: true,
    ),
  );

  AddressExternalService(Dio dio) {
    // Ensure no interceptors (e.g., auth) are attached to the public client
    _publicDio.interceptors.clear();
    _publicDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Force simple request: GET only simple headers
          options.headers.remove('Authorization');
          options.headers.remove('authorization');
          // Only allow Accept header; remove Content-Type for GET
          if (options.method.toUpperCase() == 'GET') {
            options.headers.remove('Content-Type');
            options.headers.remove('content-type');
          }
          // Remove any custom X-* headers that could trigger preflight
          options.headers.removeWhere((key, value) => key.toString().toLowerCase().startsWith('x-'));
          handler.next(options);
        },
      ),
    );
  }

  String _maybeProxy(String url) {
    final proxy = dotenv.env['CORS_PROXY_URL'];
    if (proxy != null && proxy.isNotEmpty && proxy.contains('{url}')) {
      final wrapped = proxy.replaceAll('{url}', Uri.encodeComponent(url));
      return wrapped;
    }
    return url;
  }

  Future<List<ProvinceModel>> getProvinces() async {
    try {
  String url = dotenv.env['ADDRESS_PROVINCES_URL']!;
  url = _maybeProxy(url);
      // Use public client on web (to avoid global auth headers) and also on mobile since no auth is needed
      final client = _publicDio;
  final response = await client.get(url);
      
      if (response.data['error'] == 0) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ProvinceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load provinces: ${response.data['error_text']}');
      }
    } catch (e) {
      throw Exception('Failed to fetch provinces: $e');
    }
  }

  Future<List<ProvinceModel>> getDistricts(String provinceId) async {
  try {
  final baseUrl = dotenv.env['ADDRESS_DISTRICTS_URL']!;
  String url = baseUrl.replaceAll('{provinceId}', provinceId);
  url = _maybeProxy(url);
    
    if (provinceId.isEmpty) {
      throw Exception('Province ID is empty - cannot fetch districts');
    }
    
  final response = await _publicDio.get(url);
    
    if (response.data['error'] == 0) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProvinceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load districts: ${response.data['error_text']}');
    }
  } catch (e) {
    throw Exception('Failed to fetch districts: $e');
  }
}

Future<List<WardModel>> getWards(String districtId) async {
  try {
  final baseUrl = dotenv.env['ADDRESS_WARDS_URL']!;
    
  String url = baseUrl.replaceAll('{districtId}', districtId);
  url = _maybeProxy(url);
    if (districtId.isEmpty) {
      throw Exception('District ID is empty - cannot fetch wards');
    }
    
  final response = await _publicDio.get(url);
    
    if (response.data['error'] == 0) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => WardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wards: ${response.data['error_text']}');
    }
  } catch (e) {
    throw Exception('Failed to fetch wards: $e');
  }
}
}