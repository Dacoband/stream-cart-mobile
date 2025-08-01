import 'package:dartz/dartz.dart';
import '../../entities/address/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class GetAddressesByShopUseCase {
  final AddressRepository repository;

  GetAddressesByShopUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call(String shopId) async {
    return await repository.getAddressesByShop(shopId);
  }
}