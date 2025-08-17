import 'package:dartz/dartz.dart';
import '../../entities/address/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/enums/address_type.dart';

class CreateAddressUseCase {
  final AddressRepository repository;

  CreateAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call({
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
    return await repository.createAddress(
      recipientName: recipientName,
      street: street,
      ward: ward,
      district: district,
      city: city,
      country: country ?? 'Việt Nam',
      postalCode: postalCode ?? '70000',
      phoneNumber: phoneNumber,
      isDefaultShipping: isDefaultShipping,
      latitude: latitude,
      longitude: longitude,
      type: type,
      shopId: shopId,
    );
  }
}