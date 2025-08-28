import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/shop_voucher/shop_voucher_bloc.dart';
import '../../blocs/shop_voucher/shop_voucher_event.dart';
import '../../blocs/shop_voucher/shop_voucher_state.dart';
import '../../../domain/entities/shop_voucher/available_shop_voucher_entity.dart';

class AvailableShopVouchersSheet extends StatelessWidget {
  final String? shopId;
  final double orderAmount;
  final void Function(AvailableShopVoucherItemEntity item) onSelected;

  const AvailableShopVouchersSheet({super.key, this.shopId, required this.orderAmount, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShopVoucherBloc>()..add(LoadAvailableShopVouchersEvent(orderAmount: orderAmount, shopId: shopId)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(child: Text('Chọn voucher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<ShopVoucherBloc, ShopVoucherState>(
                builder: (context, state) {
                  if (state is AvailableShopVouchersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ShopVoucherError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is AvailableShopVouchersLoaded) {
                    if (state.data.data.isEmpty) {
                      return const Center(child: Text('Không có voucher phù hợp'));
                    }
                    return ListView.separated(
                      itemCount: state.data.data.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = state.data.data[index];
                        final v = item.voucher;
                        final discountLabel = item.discountPercentage > 0
                            ? '-${item.discountPercentage.toStringAsFixed(0)}%'
                            : '-${item.discountAmount.toStringAsFixed(0)}đ';
                        return ListTile(
                          title: Text(v.code, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(item.discountMessage.isNotEmpty ? item.discountMessage : v.description ?? ''),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade50,
                            child: Text(discountLabel, style: const TextStyle(fontSize: 11)),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${item.finalAmount.toStringAsFixed(0)}đ', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                              if (v.minOrderAmount != null && v.minOrderAmount! > 0)
                                Text('ĐH tối thiểu ${v.minOrderAmount!.toStringAsFixed(0)}đ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          onTap: () {
                            onSelected(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}