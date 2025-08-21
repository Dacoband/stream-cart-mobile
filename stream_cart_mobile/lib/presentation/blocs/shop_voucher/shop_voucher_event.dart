import 'package:equatable/equatable.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';

abstract class ShopVoucherEvent extends Equatable {
  const ShopVoucherEvent();

  @override
  List<Object?> get props => [];
}

class LoadShopVouchersEvent extends ShopVoucherEvent {
  final String shopId;
  final bool? isActive;
  final int? type;
  final bool? isExpired;
  final int pageNumber;
  final int pageSize;

  const LoadShopVouchersEvent({
    required this.shopId,
    this.isActive,
    this.type,
    this.isExpired,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [shopId, isActive, type, isExpired, pageNumber, pageSize];
}

class ApplyShopVoucherEvent extends ShopVoucherEvent {
  final String code;
  final ApplyShopVoucherRequestEntity request;

  const ApplyShopVoucherEvent({
    required this.code,
    required this.request,
  });

  @override
  List<Object?> get props => [code, request];
}
