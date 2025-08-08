import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/order/order_entity.dart';

// Breakdown giá (subtotal, shipping, discount, total)
class OrderPriceBreakdownWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderPriceBreakdownWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = <_PriceRow>[
      _PriceRow('Tạm tính', order.totalPrice),
      _PriceRow('Phí vận chuyển', order.shippingFee),
      if ((order.discountAmount) > 0) _PriceRow('Giảm giá', -order.discountAmount),
    ];

    const accent = Color(0xFFB0F847);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_outlined, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              const Text(
                'Chi tiết giá',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rows.map((r) => _buildRow(r.label, r.value)).toList(),
          Container(height: 1, color: Colors.grey[200], margin: const EdgeInsets.symmetric(vertical: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withOpacity(0.6), width: 1),
                ),
                child: Text(
                  _formatVnd(order.finalAmount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202328),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value) {
    final isNegative = value < 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          Text(
            isNegative ? '-${_formatVnd(value.abs())}' : _formatVnd(value),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isNegative ? Colors.red[600] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatVnd(double amount) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return fmt.format(amount);
  }
}

class _PriceRow {
  final String label;
  final double value;
  _PriceRow(this.label, this.value);
}
