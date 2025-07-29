import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/enums/address_type.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final result = await remoteDataSource.getAddresses();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> createAddress({
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
      final result = await remoteDataSource.createAddress(
        recipientName: recipientName,
        street: street,
        ward: ward,
        district: district,
        city: city,
        country: country,
        postalCode: postalCode,
        phoneNumber: phoneNumber,
        isDefaultShipping: isDefaultShipping,
        latitude: latitude,
        longitude: longitude,
        type: type,
        shopId: shopId,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(String id, {
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
      final result = await remoteDataSource.updateAddress(
        id,
        recipientName: recipientName,
        street: street,
        ward: ward,
        district: district,
        city: city,
        country: country,
        postalCode: postalCode,
        phoneNumber: phoneNumber,
        type: type,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    try {
      await remoteDataSource.deleteAddress(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> getAddressById(String id) async {
    try {
      final result = await remoteDataSource.getAddressById(id);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> setDefaultShippingAddress(String id) async {
    try {
      final result = await remoteDataSource.setDefaultShippingAddress(id);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity?>> getDefaultShippingAddress() async {
    try {
      final result = await remoteDataSource.getDefaultShippingAddress();
      return Right(result?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddressesByType(AddressType type) async {
    try {
      final result = await remoteDataSource.getAddressesByType(type);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> assignAddressToShop(String addressId, String shopId) async {
    try {
      final result = await remoteDataSource.assignAddressToShop(addressId, shopId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> unassignAddressFromShop(String addressId) async {
    try {
      final result = await remoteDataSource.unassignAddressFromShop(addressId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddressesByShop(String shopId) async {
    try {
      final result = await remoteDataSource.getAddressesByShop(shopId);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // External API methods
  @override
  Future<Either<Failure, List<ProvinceEntity>>> getProvinces() async {
    try {
      final result = await remoteDataSource.getProvinces();
      return Right(result.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure('Failed to fetch provinces: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProvinceEntity>>> getDistricts(String provinceId) async {
    try {
      final result = await remoteDataSource.getDistricts(provinceId);
      return Right(result.map((model) => ProvinceEntity(
        id: model.id,
        fullName: model.fullName,
        name: model.name,
      )).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure('Failed to fetch districts: $e'));
    }
  }

  @override
  Future<Either<Failure, List<WardEntity>>> getWards(String districtId) async {
    try {
      final result = await remoteDataSource.getWards(districtId);
      return Right(result.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure('Failed to fetch wards: $e'));
    }
  }
}