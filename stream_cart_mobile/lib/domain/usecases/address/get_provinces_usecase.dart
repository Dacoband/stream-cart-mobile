import 'package:dartz/dartz.dart';
import '../../entities/address_entity.dart';
import '../../repositories/address_repository.dart';
import '../../../core/error/failures.dart';

class GetProvincesUseCase {
  final AddressRepository repository;

  GetProvincesUseCase(this.repository);

  Future<Either<Failure, List<ProvinceEntity>>> call() async {
    return await repository.getProvinces();
  }
}