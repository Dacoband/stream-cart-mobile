import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';

class ShopVoucherListTile extends StatelessWidget {
  final ShopVoucherEntity voucher;
  final VoidCallback? onTap;
  const ShopVoucherListTile({super.key, required this.voucher, this.onTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isExpired = voucher.endDate != null && voucher.endDate!.isBefore(now);
    final color = isExpired ? Colors.grey : AppColors.brandPrimary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bubbleNeutral,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withOpacity(0.4)),
              ),
              child: Text(
                voucher.code,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _discountText(voucher),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.brandDark,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (voucher.description != null && voucher.description!.isNotEmpty)
                Text(voucher.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                _expiryText(voucher),
                style: TextStyle(color: isExpired ? Colors.red : Colors.grey[700], fontSize: 12),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.brandDark.withOpacity(0.6)),
        onTap: onTap,
      ),
    );
  }

  String _discountText(ShopVoucherEntity v) {
    if (v.type == 1) {
      final percent = v.value.toStringAsFixed(0);
      return '-$percent% ${v.maxValue != null ? '(tối đa ${_money(v.maxValue!)})' : ''}';
    }
    return '-${_money(v.value)}';
  }

  String _expiryText(ShopVoucherEntity v) {
    if (v.endDate == null) return 'Không giới hạn thời gian';
    final d = v.endDate!;
    return 'HSD: ${d.day}/${d.month}/${d.year}';
  }

  String _money(double v) {
    final s = v.toInt().toString();
    final re = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(re, (m) => '${m[1]},') + '₫';
  }
}
