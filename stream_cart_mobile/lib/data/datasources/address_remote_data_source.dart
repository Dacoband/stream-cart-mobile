import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/enums/address_type.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/address_external_service.dart';
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  // CRUD operations for addresses
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress({
    required String recipientName,
    required String street,
    required String ward,
    required String district,
    required String city,
    String? country,
    String? postalCode,
    required String phoneNumber,
    required bool isDefaultShipping,
    required double latitude,
    required double longitude,
    required AddressType type,
    String? shopId,
  });
  Future<AddressModel> updateAddress(String id, {
    String? recipientName,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? country,
    String? postalCode,
    String? phoneNumber,
    AddressType? type,
    double? latitude,
    double? longitude,
  });
  Future<void> deleteAddress(String id);
  Future<AddressModel> getAddressById(String id);
  Future<AddressModel> setDefaultShippingAddress(String id);
  Future<AddressModel?> getDefaultShippingAddress();
  Future<List<AddressModel>> getAddressesByType(AddressType type);
  Future<AddressModel> assignAddressToShop(String addressId, String shopId);
  Future<AddressModel> unassignAddressFromShop(String addressId);
  Future<List<AddressModel>> getAddressesByShop(String shopId);

  // External API for provinces/districts/wards
  Future<List<ProvinceModel>> getProvinces();
  Future<List<ProvinceModel>> getDistricts(String provinceId);
  Future<List<WardModel>> getWards(String districtId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio _dio;
  final AddressExternalService _externalService;

  AddressRemoteDataSourceImpl(this._dio, this._externalService);

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _dio.get('/api/addresses');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get addresses');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Network timeout');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel> createAddress({
    required String recipientName,
    required String street,
    required String ward,
    required String district,
    required String city,
    String? country,
    String? postalCode,
    required String phoneNumber,
    required bool isDefaultShipping,
    required double latitude,
    required double longitude,
    required AddressType type,
    String? shopId,
  }) async {
    try {
      final data = {
        'recipientName': recipientName,
        'street': street,
        'ward': ward,
        'district': district,
        'city': city,
        'country': country ?? 'Việt Nam',
        'postalCode': postalCode ?? '70000',
        'phoneNumber': phoneNumber,
        'isDefaultShipping': isDefaultShipping,
        'latitude': latitude,
        'longitude': longitude,
        'type': type.value,
        if (shopId != null) 'shopId': shopId,
      };

      final response = await _dio.post('/api/addresses', data: data);
      
      if (response.statusCode == 201) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to create address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Invalid address data');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel> updateAddress(String id, {
    String? recipientName,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? country,
    String? postalCode,
    String? phoneNumber,
    AddressType? type,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (recipientName != null) data['recipientName'] = recipientName;
      if (street != null) data['street'] = street;
      if (ward != null) data['ward'] = ward;
      if (district != null) data['district'] = district;
      if (city != null) data['city'] = city;
      if (country != null) data['country'] = country;
      if (postalCode != null) data['postalCode'] = postalCode;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
      if (type != null) data['type'] = type.value;
      if (latitude != null) data['latitude'] = latitude;
      if (longitude != null) data['longitude'] = longitude;

      final response = await _dio.put('/api/addresses/$id', data: data);
      
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to update address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Address not found');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      final response = await _dio.delete('/api/addresses/$id');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Address not found');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel> getAddressById(String id) async {
    try {
      final response = await _dio.get('/api/addresses/$id');
      
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Address not found');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel> setDefaultShippingAddress(String id) async {
    try {
      final response = await _dio.put('/api/addresses/$id/set-default');
      
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to set default address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Address not found');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel?> getDefaultShippingAddress() async {
    try {
      final response = await _dio.get('/api/addresses/default-shipping');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return data != null ? AddressModel.fromJson(data) : null;
      } else {
        throw ServerException('Failed to get default address');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        return null; // No default address set
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<AddressModel>> getAddressesByType(AddressType type) async {
    try {
      final response = await _dio.get('/api/addresses?type=${type.value}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get addresses by type');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel> assignAddressToShop(String addressId, String shopId) async {
    try {
      final response = await _dio.put('/api/addresses/$addressId/assign-shop', 
        data: {'shopId': shopId});
      
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to assign address to shop');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Address or shop not found');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AddressModel> unassignAddressFromShop(String addressId) async {
    try {
      final response = await _dio.put('/api/addresses/$addressId/unassign-shop');
      
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to unassign address from shop');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Address not found');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<AddressModel>> getAddressesByShop(String shopId) async {
    try {
      final response = await _dio.get('/api/addresses/shop/$shopId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get addresses by shop');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  // External API methods
  @override
  Future<List<ProvinceModel>> getProvinces() async {
    try {
      return await _externalService.getProvinces();
    } catch (e) {
      throw NetworkException('Failed to fetch provinces: $e');
    }
  }

  @override
  Future<List<ProvinceModel>> getDistricts(String provinceId) async {
    try {
      return await _externalService.getDistricts(provinceId);
    } catch (e) {
      throw NetworkException('Failed to fetch districts: $e');
    }
  }

  @override
  Future<List<WardModel>> getWards(String districtId) async {
    try {
      return await _externalService.getWards(districtId);
    } catch (e) {
      throw NetworkException('Failed to fetch wards: $e');
    }
  }
}