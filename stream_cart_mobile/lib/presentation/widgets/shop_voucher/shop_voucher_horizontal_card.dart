import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';

class ShopVoucherHorizontalCard extends StatelessWidget {
  final ShopVoucherEntity voucher;
  final VoidCallback? onTap;
  const ShopVoucherHorizontalCard({super.key, required this.voucher, this.onTap});

  @override
  Widget build(BuildContext context) {
    final endDate = voucher.endDate;
    final isExpired = endDate != null && endDate.isBefore(DateTime.now());
    final borderColor = (isExpired ? Colors.grey : AppColors.brandPrimary).withOpacity(0.25);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bubbleNeutral,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.brandPrimary.withOpacity(0.4)),
                  ),
                  child: Text(
                    voucher.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _discountText(voucher),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brandDark),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              endDate == null
                  ? 'Không giới hạn'
                  : 'HSD: ${endDate.day}/${endDate.month}/${endDate.year}',
              style: TextStyle(fontSize: 12, color: isExpired ? Colors.red : Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  String _discountText(ShopVoucherEntity v) {
    if (v.type == 1) {
      final percent = v.value.toStringAsFixed(0);
      return '-$percent%${v.maxValue != null ? ' • tối đa ${_money(v.maxValue!)}' : ''}';
    }
    return '-${_money(v.value)}';
  }

  String _money(double v) {
    final s = v.toInt().toString();
    final re = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(re, (m) => '${m[1]},') + '₫';
  }
}
