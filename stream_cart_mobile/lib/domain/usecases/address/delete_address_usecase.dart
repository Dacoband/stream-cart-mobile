import 'package:dartz/dartz.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteAddress(id);
  }
}