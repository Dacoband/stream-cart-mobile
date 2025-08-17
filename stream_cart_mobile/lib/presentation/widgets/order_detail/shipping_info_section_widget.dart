import 'package:flutter/material.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/entities/order/shipping_address_entity.dart';

class ShippingInfoSectionWidget extends StatelessWidget {
  final OrderEntity order;

  const ShippingInfoSectionWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = order.shippingAddress;

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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB0F847).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB0F847).withOpacity(0.6)),
                ),
                child: const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF202328)),
              ),
              const SizedBox(width: 8),
              const Text(
                'Giao hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _line('Người nhận', address.fullName.isNotEmpty ? address.fullName : '-'),
          const SizedBox(height: 8),
          _line('Số điện thoại', address.phone.isNotEmpty ? address.phone : '-'),
          const SizedBox(height: 8),
          _line('Địa chỉ', _formatAddress(address)),
          if (order.estimatedDeliveryDate != null) ...[
            const SizedBox(height: 8),
            _line('Dự kiến giao', _formatDate(order.estimatedDeliveryDate!)),
          ],
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  static String _formatAddress(ShippingAddressEntity a) {
    final parts = <String>[
      a.addressLine1,
      a.ward,
      a.district,
      a.city,
      a.province,
    ].where((p) => p.trim().isNotEmpty).toList();
    return parts.isEmpty ? '-' : parts.join(', ');
  }

  static String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }
}
