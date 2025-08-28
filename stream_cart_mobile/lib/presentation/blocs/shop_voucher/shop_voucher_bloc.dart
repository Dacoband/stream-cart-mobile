import 'package:flutter_bloc/flutter_bloc.dart';
import 'shop_voucher_event.dart';
import 'shop_voucher_state.dart';
import '../../../domain/usecases/shop_voucher/get_shop_vouchers_usecase.dart';
import '../../../domain/usecases/shop_voucher/apply_shop_voucher_usecase.dart';
import '../../../domain/usecases/shop_voucher/get_available_shop_vouchers_usecase.dart';

class ShopVoucherBloc extends Bloc<ShopVoucherEvent, ShopVoucherState> {
  final GetShopVouchersUseCase getShopVouchersUseCase;
  final ApplyShopVoucherUseCase applyShopVoucherUseCase;
  final GetAvailableShopVouchersUseCase? getAvailableShopVouchersUseCase; // optional until DI updated

  ShopVoucherBloc({
    required this.getShopVouchersUseCase,
    required this.applyShopVoucherUseCase,
    this.getAvailableShopVouchersUseCase,
  }) : super(ShopVoucherInitial()) {
    on<LoadShopVouchersEvent>(_onLoadShopVouchers);
    on<ApplyShopVoucherEvent>(_onApplyShopVoucher);
    on<LoadAvailableShopVouchersEvent>(_onLoadAvailable);
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

  Future<void> _onLoadAvailable(
    LoadAvailableShopVouchersEvent event,
    Emitter<ShopVoucherState> emit,
  ) async {
    final usecase = getAvailableShopVouchersUseCase;
    if (usecase == null) return; // safety
    emit(AvailableShopVouchersLoading());
    final result = await usecase(
      GetAvailableShopVouchersParams(
        orderAmount: event.orderAmount,
        shopId: event.shopId,
        sortByDiscountDesc: event.sortByDiscountDesc,
      ),
    );
    result.fold(
      (failure) => emit(ShopVoucherError(failure.message)),
      (resp) => emit(AvailableShopVouchersLoaded(resp)),
    );
  }
}
