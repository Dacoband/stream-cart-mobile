import 'package:flutter_bloc/flutter_bloc.dart';
import 'shop_voucher_event.dart';
import 'shop_voucher_state.dart';
import '../../../domain/usecases/shop_voucher/get_shop_vouchers_usecase.dart';
import '../../../domain/usecases/shop_voucher/apply_shop_voucher_usecase.dart';

class ShopVoucherBloc extends Bloc<ShopVoucherEvent, ShopVoucherState> {
  final GetShopVouchersUseCase getShopVouchersUseCase;
  final ApplyShopVoucherUseCase applyShopVoucherUseCase;

  ShopVoucherBloc({
    required this.getShopVouchersUseCase,
    required this.applyShopVoucherUseCase,
  }) : super(ShopVoucherInitial()) {
    on<LoadShopVouchersEvent>(_onLoadShopVouchers);
    on<ApplyShopVoucherEvent>(_onApplyShopVoucher);
  }

  Future<void> _onLoadShopVouchers(
    LoadShopVouchersEvent event,
    Emitter<ShopVoucherState> emit,
  ) async {
    emit(ShopVoucherLoading());
    final result = await getShopVouchersUseCase(
      GetShopVouchersParams(
        shopId: event.shopId,
        isActive: event.isActive,
        type: event.type,
        isExpired: event.isExpired,
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      ),
    );
    result.fold(
      (failure) => emit(ShopVoucherError(failure.message)),
      (vouchers) => emit(ShopVouchersLoaded(vouchers)),
    );
  }

  Future<void> _onApplyShopVoucher(
    ApplyShopVoucherEvent event,
    Emitter<ShopVoucherState> emit,
  ) async {
    emit(ShopVoucherApplyLoading());
    final result = await applyShopVoucherUseCase(
      ApplyShopVoucherParams(
        code: event.code,
        request: event.request,
      ),
    );
    result.fold(
      (failure) => emit(ShopVoucherError(failure.message)),
      (response) => emit(ShopVoucherApplied(response)),
    );
  }
}
