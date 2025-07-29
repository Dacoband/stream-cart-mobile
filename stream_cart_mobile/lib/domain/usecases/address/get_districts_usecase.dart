import 'package:dartz/dartz.dart';
import '../../entities/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class GetDistrictsUseCase {
  final AddressRepository repository;

  GetDistrictsUseCase(this.repository);

  Future<Either<Failure, List<ProvinceEntity>>> call(String provinceId) async {
    return await repository.getDistricts(provinceId);
  }
}