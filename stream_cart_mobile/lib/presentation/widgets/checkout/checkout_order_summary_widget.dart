import 'package:flutter/material.dart';
import '../../../domain/entities/cart/cart_entity.dart';
import '../../blocs/deliveries/deliveries_state.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';


class CurrencyFormatter {
  static String format(num value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} ₫';
  }
}

class CheckoutOrderSummaryWidget extends StatelessWidget {
  final PreviewOrderDataEntity previewOrderData;
  final DeliveryState? deliveryState;
  final Map<String, ApplyShopVoucherDataEntity>? appliedVouchers;

  const CheckoutOrderSummaryWidget({
    super.key,
    required this.previewOrderData,
    this.deliveryState,
    this.appliedVouchers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Thông tin đơn hàng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          
          // Products by shop
          ...previewOrderData.listCartItem.map((shop) => _buildShopSection(shop)),
          
          const Divider(height: 1),
          
          // Total summary
          _buildTotalSummary(),
        ],
      ),
    );
  }

  Widget _buildShopSection(CartShopEntity shop) {
    final applied = appliedVouchers?[shop.shopId];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[50],
          child: Row(
            children: [
              const Icon(Icons.store, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  shop.shopName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Products
        ...shop.products.map((product) => _buildProductItem(product)),
        if (applied != null && applied.isApplied) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Giảm giá voucher', style: TextStyle(color: Colors.red)),
                Text('-${CurrencyFormatter.format(applied.discountAmount)}', style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tạm tính sau giảm'),
                Text(CurrencyFormatter.format(applied.finalAmount), style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildProductItem(CartItemEntity product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.primaryImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Builder(builder: (_) {
                  String? label;
                  try {
                    final attrs = product.attributes;
                    String? sku;
                    String? name;
                    if (attrs != null && attrs.isNotEmpty) {
                      final lower = attrs.map((k, v) => MapEntry(k.toString().toLowerCase(), v));
                      if (lower.containsKey('sku')) {
                        final v = lower['sku'];
                        if (v != null && v.toString().trim().isNotEmpty) sku = v.toString().trim();
                      }
                      final parts = <String>[];
                      attrs.forEach((k, v) {
                        if (k.toString().toLowerCase() == 'sku') return;
                        final vv = v?.toString().trim();
                        if (vv != null && vv.isNotEmpty) parts.add(vv);
                      });
                      if (parts.isNotEmpty) name = parts.join(' - ');
                    }
                    if (sku == null) {
                      final vid = (product.variantId ?? '').trim();
                      final guidLike = RegExp(r'^[0-9a-fA-F-]{30,}$');
                      if (vid.isNotEmpty && !guidLike.hasMatch(vid)) sku = vid;
                    }
                    if (sku != null && name != null) label = 'SKU: $sku • $name';
                    else if (sku != null) label = 'SKU: $sku';
                    else if (name != null) label = name;
                  } catch (_) {}
                  if (label == null) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.format(product.priceData.currentPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    Text(
                      'x${product.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSummary() {
    final deliveryFee = deliveryState is DeliveryLoaded 
        ? (deliveryState as DeliveryLoaded).totalDeliveryFee 
        : 0.0;
    double discountedSubtotal = 0;
    for (final shop in previewOrderData.listCartItem) {
      final applied = appliedVouchers?[shop.shopId];
      if (applied != null && applied.isApplied) {
        discountedSubtotal += applied.finalAmount;
      } else {
        discountedSubtotal += shop.totalPriceInShop;
      }
    }
    final double voucherDiscount = (previewOrderData.subTotal - discountedSubtotal).clamp(0, double.infinity);
    final double finalTotal = discountedSubtotal + deliveryFee;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryRow(
            'Tạm tính',
            CurrencyFormatter.format(previewOrderData.subTotal),
          ),
          const SizedBox(height: 8),
      _buildDeliveryFeeRow(deliveryFee),
          const SizedBox(height: 8),
      if (voucherDiscount > 0) ...[
            _buildSummaryRow(
              'Giảm giá',
        '-${CurrencyFormatter.format(voucherDiscount)}',
              isDiscount: true,
            ),
            const SizedBox(height: 8),
          ],
          const Divider(),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Tổng cộng',
            CurrencyFormatter.format(finalTotal),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryFeeRow(double deliveryFee) {
    if (deliveryState is! DeliveryLoaded) {
      return _buildSummaryRow(
        'Phí vận chuyển',
        'Tính khi chọn',
        isDeliveryFee: true,
      );
    }

    return _buildSummaryRow(
      'Phí vận chuyển',
      deliveryFee > 0 
          ? CurrencyFormatter.format(deliveryFee)
          : 'Chưa chọn',
      isDeliveryFee: true,
    );
  }

  Widget _buildSummaryRow(
    String label, 
    String value, {
    bool isTotal = false,
    bool isDiscount = false,
    bool isDeliveryFee = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal 
                ? const Color(0xFF4CAF50)
                : isDiscount 
                    ? Colors.red 
                    : isDeliveryFee
                        ? Colors.orange
                        : Colors.black87,
          ),
        ),
      ],
    );
  }
}