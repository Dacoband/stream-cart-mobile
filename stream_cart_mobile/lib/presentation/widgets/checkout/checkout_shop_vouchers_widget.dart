import 'package:flutter/material.dart';
import '../../../domain/entities/cart/cart_entity.dart';
import '../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/shop_voucher/shop_voucher_bloc.dart';
import '../../blocs/shop_voucher/shop_voucher_event.dart';
import '../../blocs/shop_voucher/shop_voucher_state.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';
import '../../../core/di/dependency_injection.dart' show getIt;

class CheckoutShopVouchersWidget extends StatelessWidget {
  final List<CartShopEntity> shops;
  final Map<String, String> initialCodes;
  final void Function(String shopId, String code) onCodeChanged;
  final String? orderId;
  final void Function(String shopId, ApplyShopVoucherDataEntity data)? onApplied;

  const CheckoutShopVouchersWidget({
    super.key,
    required this.shops,
    required this.initialCodes,
    required this.onCodeChanged,
    this.orderId,
    this.onApplied,
  });

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) return const SizedBox.shrink();
    return Column(
      children: shops.map((s) => _ShopVoucherRow(
        shop: s,
        initialCode: initialCodes[s.shopId] ?? '',
        onCodeChanged: onCodeChanged,
        orderId: orderId,
  onApplied: onApplied,
      )).toList(),
    );
  }
}

class _ShopVoucherRow extends StatefulWidget {
  final CartShopEntity shop;
  final String initialCode;
  final void Function(String shopId, String code) onCodeChanged;
  final String? orderId;
  final void Function(String shopId, ApplyShopVoucherDataEntity data)? onApplied;
  const _ShopVoucherRow({required this.shop, required this.initialCode, required this.onCodeChanged, this.orderId, this.onApplied});

  @override
  State<_ShopVoucherRow> createState() => _ShopVoucherRowState();
}

class _ShopVoucherRowState extends State<_ShopVoucherRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void didUpdateWidget(covariant _ShopVoucherRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCode != widget.initialCode) {
      _controller.text = widget.initialCode;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: BlocProvider(
        create: (_) => getIt<ShopVoucherBloc>(),
        child: BlocConsumer<ShopVoucherBloc, ShopVoucherState>(
        listener: (context, state) {
          if (state is ShopVoucherApplied) {
            final ok = state.response.success && (state.response.data?.isApplied ?? false);
            final msg = state.response.data?.message.isNotEmpty == true
                ? state.response.data!.message
                : state.response.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: ok ? Colors.green : Colors.orange),
            );
              if (ok && state.response.data != null) {
                widget.onApplied?.call(widget.shop.shopId, state.response.data!);
              }
          }
          if (state is ShopVoucherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isApplying = state is ShopVoucherApplyLoading;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.shop.shopName, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brandDark)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nhập mã voucher của shop',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.brandPrimary.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.brandPrimary.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.brandPrimary),
                        ),
                      ),
                      onChanged: (val) => widget.onCodeChanged(widget.shop.shopId, val),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isApplying)
                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              else
                ElevatedButton(
                  onPressed: () {
                    final code = _controller.text.trim();
                    if (code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập mã voucher')), 
                      );
                      return;
                    }
                    final req = ApplyShopVoucherRequestEntity(
                      code: code,
                      orderAmount: widget.shop.totalPriceInShop,
                      orderId: (widget.orderId != null && widget.orderId!.isNotEmpty) ? widget.orderId : null,
                    );
                    context.read<ShopVoucherBloc>().add(ApplyShopVoucherEvent(code: code, request: req));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary, foregroundColor: Colors.white),
                  child: const Text('Áp dụng'),
                ),
              IconButton(
                tooltip: 'Xóa mã',
                icon: const Icon(Icons.clear, color: Colors.redAccent),
                onPressed: () {
                  _controller.clear();
                  widget.onCodeChanged(widget.shop.shopId, '');
                },
              ),
            ],
          );
        },
      ),
    ),
  );
  }
}
