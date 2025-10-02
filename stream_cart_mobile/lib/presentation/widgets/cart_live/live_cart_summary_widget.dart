import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

class LiveCartSummaryWidget extends StatelessWidget {
  final PreviewOrderLiveModel cart;
  final Set<String> selectedIds;
  final VoidCallback? onCheckout;
  final VoidCallback? onClear;

  const LiveCartSummaryWidget({
    super.key,
    required this.cart,
    required this.selectedIds,
    this.onCheckout,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
  final totalSelected = _selectedItemsTotal();
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10 + 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedIds.isEmpty
                          ? 'Chưa chọn sản phẩm'
                          : 'Đã chọn (${selectedIds.length}) • ${_fmt(totalSelected)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    if (selectedIds.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _fmt(_selectedItemsOriginalTotal()),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (_selectedItemsDiscount() > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${_discountPercent()}%',
                                    style: const TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tạm tính: ${_fmt(_selectedItemsSubtotal())}  Giảm: ${_fmt(_selectedItemsDiscount())}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: selectedIds.isEmpty ? null : onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF89C036),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Thanh toán'),
              ),
            ],
          ),
          if (onClear != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.clear_all, size: 16, color: Colors.redAccent),
                label: const Text(
                  'Xóa tất cả',
                  style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _selectedItemsSubtotal() {
    if (selectedIds.isEmpty) return 0;
    double sum = 0;
    for (final shop in cart.listCartItem) {
      for (final p in shop.products) {
        if (selectedIds.contains(p.cartItemId)) {
          sum += p.priceData.currentPrice * p.quantity;
        }
      }
    }
    return sum;
  }

  double _selectedItemsDiscount() {
    if (selectedIds.isEmpty) return 0;
    double discount = 0;
    for (final shop in cart.listCartItem) {
      for (final p in shop.products) {
        if (selectedIds.contains(p.cartItemId)) {
          final original = p.priceData.originalPrice * p.quantity;
          final current = p.priceData.currentPrice * p.quantity;
          discount += (original - current).clamp(0, double.infinity);
        }
      }
    }
    return discount;
  }

  double _selectedItemsTotal() => _selectedItemsSubtotal();

  double _selectedItemsOriginalTotal() {
    if (selectedIds.isEmpty) return 0;
    double sum = 0;
    for (final shop in cart.listCartItem) {
      for (final p in shop.products) {
        if (selectedIds.contains(p.cartItemId)) {
          sum += p.priceData.originalPrice * p.quantity;
        }
      }
    }
    return sum;
  }

  int _discountPercent() {
    final original = _selectedItemsOriginalTotal();
    if (original <= 0) return 0;
    final discount = _selectedItemsDiscount();
    return (discount / original * 100).round();
  }

  String _fmt(double v) => CurrencyFormatter.formatVND(v);
}
