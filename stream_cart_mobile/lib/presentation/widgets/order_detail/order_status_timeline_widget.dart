import 'package:flutter/material.dart';

// Timeline trạng thái đơn hàng
class OrderStatusTimelineWidget extends StatelessWidget {
  final int? status; // 0-4

  const OrderStatusTimelineWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const steps = [
      _Step('Đặt hàng', Icons.shopping_cart_outlined),
      _Step('Xác nhận', Icons.verified_outlined),
      _Step('Chuẩn bị', Icons.inventory_2_outlined),
      _Step('Đang giao', Icons.local_shipping_outlined),
      _Step('Hoàn thành', Icons.check_circle_outline),
    ];

    final active = (status ?? -1).clamp(0, steps.length - 1);
    const accent = Color(0xFFB0F847);

    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _Dot(label: steps[i].label, icon: steps[i].icon, active: i <= active),
            if (i != steps.length - 1)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: i < active ? [accent, accent] : [Colors.grey.shade300, Colors.grey.shade300],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  const _Dot({required this.label, required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    const dark = Color(0xFF202328);
    const accent = Color(0xFFB0F847);
    final fg = active ? dark : Colors.grey[600]!;
    final bg = active ? accent.withOpacity(0.2) : Colors.grey[200]!;
    final border = active ? accent : Colors.grey[300]!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 2),
            boxShadow: [
              if (active)
                BoxShadow(
                  color: accent.withOpacity(0.35),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Icon(icon, size: 20, color: fg),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 66,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: fg,
            ),
          ),
        ),
      ],
    );
  }
}

class _Step {
  final String label;
  final IconData icon;
  const _Step(this.label, this.icon);
}
