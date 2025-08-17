import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/shop_repository.dart';

class GetProductCountByShopUseCase {
  final ShopRepository repository;

  GetProductCountByShopUseCase(this.repository);

  Future<Either<Failure, int>> call(String shopId) async {
    return await repository.getProductCountByShop(shopId);
  }
}
