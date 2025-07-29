import 'package:dartz/dartz.dart';
import '../../entities/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/enums/address_type.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call({
    required String id,
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
    final currentAddressResult = await repository.getAddressById(id);
    
    return currentAddressResult.fold(
      (failure) => Left(failure),
      (currentAddress) async {
        return await repository.updateAddress(
          id,
          recipientName: recipientName ?? currentAddress.recipientName,
          street: street ?? currentAddress.street,
          ward: ward ?? currentAddress.ward,
          district: district ?? currentAddress.district,
          city: city ?? currentAddress.city,
          country: country ?? currentAddress.country,
          postalCode: postalCode ?? currentAddress.postalCode,
          phoneNumber: phoneNumber ?? currentAddress.phoneNumber,
          type: type ?? currentAddress.type,
          latitude: latitude ?? currentAddress.latitude,
          longitude: longitude ?? currentAddress.longitude,
        );
      },
    );
  }
}