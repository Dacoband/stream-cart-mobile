import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/shop_voucher/available_shop_voucher_entity.dart';
import '../../repositories/shop_voucher/shop_voucher_repository.dart';

class GetAvailableShopVouchersParams {
  final double orderAmount;
  final String? shopId;
  final bool sortByDiscountDesc;

  const GetAvailableShopVouchersParams({
    required this.orderAmount,
    this.shopId,
    this.sortByDiscountDesc = true,
  });
}

class GetAvailableShopVouchersUseCase {
  final ShopVoucherRepository repository;
  GetAvailableShopVouchersUseCase(this.repository);

  Future<Either<Failure, AvailableShopVouchersResponseEntity>> call(GetAvailableShopVouchersParams params) {
    return repository.getAvailableVouchers(
      orderAmount: params.orderAmount,
      shopId: params.shopId,
      sortByDiscountDesc: params.sortByDiscountDesc,
    );
  }
}