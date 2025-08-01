import 'package:dartz/dartz.dart';
import '../../entities/address/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class GetDefaultShippingAddressUseCase {
  final AddressRepository repository;

  GetDefaultShippingAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity?>> call() async {
    return await repository.getDefaultShippingAddress();
  }
}