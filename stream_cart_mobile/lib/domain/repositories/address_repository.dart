
import 'package:dartz/dartz.dart';

import '../../core/enums/address_type.dart';
import '../../core/error/failures.dart';
import '../entities/address/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  Future<Either<Failure, AddressEntity>> createAddress({
    required String recipientName,
    required String street,
    required String ward,
    required String district,
    required String city,
    String? country, // Default is 'Việt Nam'
    String? postalCode, // Default is '70000'
    required String phoneNumber,
    required bool isDefaultShipping,
    required double latitude,
    required double longitude,
    required AddressType type,
    String? shopId,
  });

  Future<Either<Failure, AddressEntity>> updateAddress(String id, {
    String? recipientName,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? country, // Default is 'Việt Nam'
    String? postalCode, // Default is '70000'
    String? phoneNumber,
    AddressType? type,
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, void>> deleteAddress(String id);

  Future<Either<Failure, AddressEntity>> getAddressById(String id);

  Future<Either<Failure, AddressEntity>> setDefaultShippingAddress(String id);

  Future<Either<Failure, AddressEntity?>> getDefaultShippingAddress();

  Future<Either<Failure, List<AddressEntity>>> getAddressesByType(AddressType type);

  Future<Either<Failure, AddressEntity>> assignAddressToShop(String id, String shopId);

  Future<Either<Failure, AddressEntity>> unassignAddressFromShop(String id);

  Future<Either<Failure, List<AddressEntity>>> getAddressesByShop(String shopId);

  // External API for provinces/districts/wards
  Future<Either<Failure, List<ProvinceEntity>>> getProvinces();

  Future<Either<Failure, List<ProvinceEntity>>> getDistricts(String provinceId);

  Future<Either<Failure, List<WardEntity>>> getWards(String districtId);
}