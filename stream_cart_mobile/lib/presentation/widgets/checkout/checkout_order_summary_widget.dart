import 'package:flutter/material.dart';
import '../../../domain/entities/cart/cart_entity.dart';
import '../../blocs/deliveries/deliveries_state.dart';


class CurrencyFormatter {
  static String format(num value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} ₫';
  }
}

class CheckoutOrderSummaryWidget extends StatelessWidget {
  final PreviewOrderDataEntity previewOrderData;
  final DeliveryState? deliveryState;

  const CheckoutOrderSummaryWidget({
    super.key,
    required this.previewOrderData,
    this.deliveryState,
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
                if (product.variantId != null && product.variantId!.isNotEmpty) ...[
                  Text(
                    'Phân loại: ${product.variantId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
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
    // Calculate delivery fee
    final deliveryFee = deliveryState is DeliveryLoaded 
        ? (deliveryState as DeliveryLoaded).totalDeliveryFee 
        : 0.0;
    final double finalTotal = previewOrderData.totalAmount + deliveryFee;
    
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
          if (previewOrderData.discount > 0) ...[
            _buildSummaryRow(
              'Giảm giá',
              '-${CurrencyFormatter.format(previewOrderData.discount)}',
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