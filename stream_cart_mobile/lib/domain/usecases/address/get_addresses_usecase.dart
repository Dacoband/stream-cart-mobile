import 'package:dartz/dartz.dart';
import '../../entities/address/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call() async {
    return await repository.getAddresses();
  }
}