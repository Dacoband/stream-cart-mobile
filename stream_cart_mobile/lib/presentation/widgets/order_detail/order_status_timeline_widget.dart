import 'package:flutter/material.dart';

// Timeline trạng thái đơn hàng
class OrderStatusTimelineWidget extends StatelessWidget {
  final int? status; // Backend 0..10

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

    // Map backend enum to step index:
    // 0 Waiting,1 Pending -> step 0 (Đặt hàng)
    // 2 Processing,6 Packed -> step 1 (Xác nhận)
    // 3 Shipped -> step 2 (Chuẩn bị) (or could treat as shipped vs prepared)
    // 7 OnDelivery -> step 3 (Đang giao)
    // 4 Delivered,10 Completed -> step 4 (Hoàn thành)
    // 5 Cancelled -> treat as 0 but can style differently (not handled here)
    // 8 Returning,9 Refunded -> treat as 4 (after completion pipeline) or keep 3 if still returning; choose 4 for now.
    int mapped;
    switch (status) {
      case 0:
      case 1:
        mapped = 0;
        break;
      case 2:
      case 6:
        mapped = 1;
        break;
      case 3:
        mapped = 2;
        break;
      case 7:
        mapped = 3;
        break;
      case 4:
      case 10:
      case 8:
      case 9:
        mapped = 4;
        break;
      case 5: // Cancelled
        mapped = 0; // show initial stage only; optionally could add cancelled overlay elsewhere
        break;
      default:
        mapped = 0;
    }
    final active = mapped.clamp(0, steps.length - 1);
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
