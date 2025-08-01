import 'package:dartz/dartz.dart';
import '../../entities/address/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class AssignAddressToShopUseCase {
  final AddressRepository repository;

  AssignAddressToShopUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call(String addressId, String shopId) async {
    return await repository.assignAddressToShop(addressId, shopId);
  }
}