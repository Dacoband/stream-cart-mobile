import 'package:dartz/dartz.dart';
import '../../entities/shop_voucher/shop_voucher_entity.dart';
import '../../repositories/shop_voucher/shop_voucher_repository.dart';
import '../../../core/error/failures.dart';

class ApplyShopVoucherParams {
  final String code;
  final ApplyShopVoucherRequestEntity request;

  const ApplyShopVoucherParams({
    required this.code,
    required this.request,
  });
}

class ApplyShopVoucherUseCase {
  final ShopVoucherRepository repository;

  ApplyShopVoucherUseCase(this.repository);

  Future<Either<Failure, ApplyShopVoucherResponseEntity>> call(ApplyShopVoucherParams params) {
    return repository.applyVoucher(
      code: params.code,
      request: params.request,
    );
  }
}
