import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/flash-sale/flash_sale_entity.dart';
import '../../repositories/flash_sale_repository.dart';

class GetFlashSalesUseCase {
  final FlashSaleRepository repository;

  GetFlashSalesUseCase({required this.repository});

  Future<Either<Failure, List<FlashSaleEntity>>> call() async {
    return await repository.getFlashSales();
  }
}
