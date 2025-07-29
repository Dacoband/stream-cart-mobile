import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/models/address_model.dart';

class AddressExternalService {
  final Dio _dio;

  AddressExternalService(this._dio);

  Future<List<ProvinceModel>> getProvinces() async {
    try {
      final url = dotenv.env['ADDRESS_PROVINCES_URL']!;
      final response = await _dio.get(url);
      
      if (response.data['error'] == 0) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ProvinceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      throw Exception('Error fetching provinces: $e');
    }
  }

  Future<List<ProvinceModel>> getDistricts(String provinceId) async {
    try {
      final baseUrl = dotenv.env['ADDRESS_DISTRICTS_URL']!;
      final url = baseUrl.replaceAll('\${provinceId}', provinceId);
      final response = await _dio.get(url);
      
      if (response.data['error'] == 0) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ProvinceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      throw Exception('Error fetching districts: $e');
    }
  }

  Future<List<WardModel>> getWards(String districtId) async {
    try {
      final baseUrl = dotenv.env['ADDRESS_WARDS_URL']!;
      final url = baseUrl.replaceAll('\${districtId}', districtId);
      final response = await _dio.get(url);
      
      if (response.data['error'] == 0) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => WardModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load wards');
      }
    } catch (e) {
      throw Exception('Error fetching wards: $e');
    }
  }
}