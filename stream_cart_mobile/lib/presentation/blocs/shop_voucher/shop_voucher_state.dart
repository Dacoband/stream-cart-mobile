import 'package:equatable/equatable.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';
import '../../../domain/entities/shop_voucher/available_shop_voucher_entity.dart';

abstract class ShopVoucherState extends Equatable {
  const ShopVoucherState();

  @override
  List<Object?> get props => [];
}

class ShopVoucherInitial extends ShopVoucherState {}

class ShopVoucherLoading extends ShopVoucherState {}

class ShopVouchersLoaded extends ShopVoucherState {
  final ShopVouchersResponseEntity vouchers;

  const ShopVouchersLoaded(this.vouchers);

  @override
  List<Object?> get props => [vouchers];
}

class ShopVoucherApplyLoading extends ShopVoucherState {}

class ShopVoucherApplied extends ShopVoucherState {
  final ApplyShopVoucherResponseEntity response;

  const ShopVoucherApplied(this.response);

  @override
  List<Object?> get props => [response];
}

class AvailableShopVouchersLoading extends ShopVoucherState {}

class AvailableShopVouchersLoaded extends ShopVoucherState {
  final AvailableShopVouchersResponseEntity data;
  const AvailableShopVouchersLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class ShopVoucherError extends ShopVoucherState {
  final String message;

  const ShopVoucherError(this.message);

  @override
  List<Object?> get props => [message];
}
