import 'package:dartz/dartz.dart';
import '../../entities/shop_voucher/shop_voucher_entity.dart';
import '../../repositories/shop_voucher/shop_voucher_repository.dart';
import '../../../core/error/failures.dart';

class GetShopVouchersParams {
  final String shopId;
  final bool? isActive;
  final int? type;
  final bool? isExpired;
  final int pageNumber;
  final int pageSize;

  const GetShopVouchersParams({
    required this.shopId,
    this.isActive,
    this.type,
    this.isExpired,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

class GetShopVouchersUseCase {
  final ShopVoucherRepository repository;

  GetShopVouchersUseCase(this.repository);

  Future<Either<Failure, ShopVouchersResponseEntity>> call(GetShopVouchersParams params) {
    return repository.getVouchers(
      shopId: params.shopId,
      isActive: params.isActive,
      type: params.type,
      isExpired: params.isExpired,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
    );
  }
}
