import 'package:dartz/dartz.dart';
import '../../entities/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class GetWardsUseCase {
  final AddressRepository repository;

  GetWardsUseCase(this.repository);

  Future<Either<Failure, List<WardEntity>>> call(String districtId) async {
    return await repository.getWards(districtId);
  }
}