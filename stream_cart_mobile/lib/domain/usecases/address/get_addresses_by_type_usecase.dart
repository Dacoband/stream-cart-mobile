import 'package:dartz/dartz.dart';
import '../../entities/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/enums/address_type.dart';

class GetAddressesByTypeUseCase {
  final AddressRepository repository;

  GetAddressesByTypeUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call(AddressType type) async {
    return await repository.getAddressesByType(type);
  }
}