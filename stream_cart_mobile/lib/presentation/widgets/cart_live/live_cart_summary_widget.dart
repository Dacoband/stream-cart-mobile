import 'package:flutter/material.dart';
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
                          ? 'Tổng: ${_fmt(cart.totalAmount)}'
                          : 'Chọn (${selectedIds.length}) • ${_fmt(totalSelected)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tạm tính: ${_fmt(cart.subTotal)}  Giảm: ${_fmt(cart.discount)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
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

  double _selectedItemsTotal() {
    // Since grouping by shop not fully implemented, fallback to full total if selectedIds not empty
    if (selectedIds.isEmpty) return 0;
    // Without per-item price reference here, return proportionally (approx) or full total.
    return cart.totalAmount; // placeholder until item-level mapping provided externally
  }

  String _fmt(double v) => '${v.toStringAsFixed(0)}₫';
}
