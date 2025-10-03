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
      _Step('Thanh toán', Icons.payment_outlined),
      _Step('Xác nhận', Icons.verified_outlined),
      _Step('Đóng gói', Icons.inventory_2_outlined),
      _Step('Giao hàng', Icons.local_shipping_outlined),
      _Step('Thành công', Icons.check_circle_outline),
    ];

    // Map backend enum to step index:
    // 0 Waiting -> step 0 (Thanh toán) - chờ thanh toán
    // 1 Pending -> step 1 (Xác nhận) - chờ shop xác nhận
    // 2 Processing -> step 2 (Đóng gói) - shop đang đóng gói
    // 6 Packed -> step 2 (Đóng gói) - đã đóng gói
    // 3 Shipped,7 OnDelivery -> step 3 (Giao hàng)
    // 4 Delivered,10 Completed -> step 4 (Thành công)
    // 5 Cancelled,8 Returning,9 Refunded -> handle separately
    int mapped;
    switch (status) {
      case 0: // Waiting - chờ thanh toán
        mapped = 0;
        break;
      case 1: // Pending - chờ xác nhận
        mapped = 1;
        break;
      case 2: // Processing - đang đóng gói
      case 6: // Packed - đã đóng gói
        mapped = 2;
        break;
      case 3: // Shipped
      case 7: // OnDelivery - đang giao hàng
        mapped = 3;
        break;
      case 4: // Delivered - đã giao
      case 10: // Completed - thành công
        mapped = 4;
        break;
      case 5: // Cancelled
      case 8: // Returning
      case 9: // Refunded
        mapped = 0; // show initial stage only
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double labelWidth = 66; // width used by each step (text)
          const double connectorMin = 24; // minimal width between steps when cramped
          final int n = steps.length;
          final double minRequired = n * labelWidth + (n - 1) * connectorMin;

          // If there's enough width, keep the flexible layout with Expanded connectors
          if (constraints.maxWidth >= minRequired) {
            return Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  _Dot(label: steps[i].label, icon: steps[i].icon, active: i <= active, labelWidth: labelWidth),
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
            );
          }

          // Otherwise, allow horizontal scrolling with fixed-size connectors
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  _Dot(label: steps[i].label, icon: steps[i].icon, active: i <= active, labelWidth: labelWidth),
                  if (i != steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: connectorMin,
                        height: 2,
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
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final double labelWidth;
  const _Dot({required this.label, required this.icon, required this.active, this.labelWidth = 66});

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
          child: Icon(icon, size: 18, color: fg),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: labelWidth,
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
