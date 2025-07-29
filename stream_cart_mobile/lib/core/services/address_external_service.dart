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
      print('Error fetching provinces: $e');
      // Fallback to mock data
      return _getMockProvinces();
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
      print('Error fetching districts: $e');
      // Fallback to mock data
      return _getMockDistricts(provinceId);
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
      print('Error fetching wards: $e');
      // Fallback to mock data
      return _getMockWards(districtId);
    }
  }

  // Mock data methods
  List<ProvinceModel> _getMockProvinces() {
    return [
      ProvinceModel(
        id: '79',
        name: 'Hồ Chí Minh',
        fullName: 'Thành phố Hồ Chí Minh',
      ),
      ProvinceModel(
        id: '01',
        name: 'Hà Nội',
        fullName: 'Thành phố Hà Nội',
      ),
      ProvinceModel(
        id: '48',
        name: 'Đà Nẵng',
        fullName: 'Thành phố Đà Nẵng',
      ),
      ProvinceModel(
        id: '92',
        name: 'Cần Thơ',
        fullName: 'Thành phố Cần Thơ',
      ),
    ];
  }

  List<ProvinceModel> _getMockDistricts(String provinceId) {
    final Map<String, List<Map<String, dynamic>>> mockData = {
      '79': [
        {'id': '760', 'name': 'Quận 1', 'full_name': 'Quận 1'},
        {'id': '769', 'name': 'Quận 2', 'full_name': 'Quận 2'},
        {'id': '770', 'name': 'Quận 3', 'full_name': 'Quận 3'},
        {'id': '773', 'name': 'Quận 7', 'full_name': 'Quận 7'},
      ],
      '01': [
        {'id': '001', 'name': 'Ba Đình', 'full_name': 'Quận Ba Đình'},
        {'id': '002', 'name': 'Hoàn Kiếm', 'full_name': 'Quận Hoàn Kiếm'},
      ],
      '48': [
        {'id': '490', 'name': 'Hải Châu', 'full_name': 'Quận Hải Châu'},
      ],
      '92': [
        {'id': '916', 'name': 'Ninh Kiều', 'full_name': 'Quận Ninh Kiều'},
      ],
    };

    final districts = mockData[provinceId] ?? [];
    return districts.map((json) => ProvinceModel(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
    )).toList();
  }

  List<WardModel> _getMockWards(String districtId) {
    final Map<String, List<Map<String, dynamic>>> mockData = {
      '760': [
        {'id': '26734', 'name': 'Bến Nghé', 'full_name': 'Phường Bến Nghé'},
        {'id': '26737', 'name': 'Bến Thành', 'full_name': 'Phường Bến Thành'},
      ],
      '769': [
        {'id': '27259', 'name': 'Thảo Điền', 'full_name': 'Phường Thảo Điền'},
      ],
      '770': [
        {'id': '27268', 'name': 'Võ Thị Sáu', 'full_name': 'Phường Võ Thị Sáu'},
      ],
      '773': [
        {'id': '27301', 'name': 'Tân Thuận Đông', 'full_name': 'Phường Tân Thuận Đông'},
      ],
      '001': [
        {'id': '00001', 'name': 'Phúc Xá', 'full_name': 'Phường Phúc Xá'},
      ],
      '002': [
        {'id': '00025', 'name': 'Hàng Bông', 'full_name': 'Phường Hàng Bông'},
      ],
      '490': [
        {'id': '20203', 'name': 'Thạch Thang', 'full_name': 'Phường Thạch Thang'},
      ],
      '916': [
        {'id': '31117', 'name': 'Xuân Khánh', 'full_name': 'Phường Xuân Khánh'},
      ],
    };

    final wards = mockData[districtId] ?? [];
    return wards.map((json) => WardModel(
      id: json['id'],
      fullName: json['full_name'],
      latitude: '0.0', 
      longitude: '0.0', 
    )).toList();
  }
}