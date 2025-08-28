import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';

import '../../entities/shop_voucher/shop_voucher_entity.dart';
import '../../entities/shop_voucher/available_shop_voucher_entity.dart';

abstract class ShopVoucherRepository {
  /// - [shopId]: Required path parameter of the shop.
  /// - [isActive]: Filter by active status.
  /// - [type]: 1 = percentage, 2 = fixed amount.
  /// - [isExpired]: Filter expired state.
  /// - [pageNumber], [pageSize]: Pagination (defaults: 1, 10).
  Future<Either<Failure, ShopVouchersResponseEntity>> getVouchers({
    required String shopId,
    bool? isActive,
    int? type,
    bool? isExpired,
    int pageNumber = 1,
    int pageSize = 10,
  });

  /// - [code]: Voucher code (path parameter).
  /// - [request]: Body contains code, orderAmount, orderId.
  Future<Either<Failure, ApplyShopVoucherResponseEntity>> applyVoucher({
    required String code,
    required ApplyShopVoucherRequestEntity request,
  });

  Future<Either<Failure, AvailableShopVouchersResponseEntity>> getAvailableVouchers({
    required double orderAmount,
    String? shopId,
    bool sortByDiscountDesc = true,
  });
}