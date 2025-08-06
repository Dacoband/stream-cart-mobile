import 'package:flutter/material.dart';
import '../../blocs/deliveries/deliveries_state.dart';
import '../../../domain/entities/cart/cart_entity.dart';

class CurrencyFormatter {
  static String format(num value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} ₫';
  }
}

class CheckoutBottomBarWidget extends StatelessWidget {
  final PreviewOrderDataEntity previewOrderData;
  final DeliveryState deliveryState;
  final String selectedPaymentMethod;
  final VoidCallback onPlaceOrder;

  const CheckoutBottomBarWidget({
    super.key,
    required this.previewOrderData,
    required this.deliveryState,
    required this.selectedPaymentMethod,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    final deliveryFee = deliveryState is DeliveryLoaded 
        ? (deliveryState as DeliveryLoaded).totalDeliveryFee 
        : 0.0;
    
    final finalTotal = previewOrderData.totalAmount + deliveryFee;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Price breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tạm tính:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    CurrencyFormatter.format(previewOrderData.totalAmount),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phí vận chuyển:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    deliveryFee > 0 
                        ? CurrencyFormatter.format(deliveryFee)
                        : 'Chưa chọn',
                    style: TextStyle(
                      fontSize: 14,
                      color: deliveryFee > 0 ? Colors.black : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              
              // Total and order button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng thanh toán:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(finalTotal),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _canPlaceOrder() ? onPlaceOrder : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Đặt hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canPlaceOrder() {
    // Check if delivery services are selected
    if (deliveryState is! DeliveryLoaded) {
      return false;
    }
    
    final state = deliveryState as DeliveryLoaded;
    return state.hasSelectedAllServices;
  }
}