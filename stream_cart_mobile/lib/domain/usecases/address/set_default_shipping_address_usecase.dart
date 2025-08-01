import 'package:dartz/dartz.dart';
import '../../entities/address/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class SetDefaultShippingAddressUseCase {
  final AddressRepository repository;

  SetDefaultShippingAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call(String id) async {
    return await repository.setDefaultShippingAddress(id);
  }
}