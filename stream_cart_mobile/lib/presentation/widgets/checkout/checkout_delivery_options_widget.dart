import 'package:flutter/material.dart';
import '../../blocs/deliveries/deliveries_state.dart';
import '../../../domain/entities/deliveries/service_response_entity.dart';

class CheckoutDeliveryOptionsWidget extends StatelessWidget {
  final DeliveryState deliveryState;
  final Function(String shopId, int serviceTypeId) onServiceSelected;

  const CheckoutDeliveryOptionsWidget({
    super.key,
    required this.deliveryState,
    required this.onServiceSelected,
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
              'Phương thức giao hàng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          _buildDeliveryContent(),
        ],
      ),
    );
  }

  Widget _buildDeliveryContent() {
    if (deliveryState is DeliveryLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
      );
    }

    if (deliveryState is DeliveryLoaded) {
      final state = deliveryState as DeliveryLoaded;
      return _buildDeliveryOptions(state);
    }

    if (deliveryState is DeliveryError) {
      final error = deliveryState as DeliveryError;
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Vui lòng chọn địa chỉ giao hàng để xem phương thức vận chuyển',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDeliveryOptions(DeliveryLoaded state) {
    // Group services by shop
    final servicesByShop = <String, List<ServiceResponseEntity>>{};
    for (final service in state.deliveryPreview.serviceResponses) {
      servicesByShop.putIfAbsent(service.shopId, () => []).add(service);
    }

    return Column(
      children: servicesByShop.entries.map((entry) {
        final shopId = entry.key;
        final services = entry.value;
        final shopName = services.first.serviceName;
        
        return _buildShopDeliverySection(shopId, shopName, services, state, servicesByShop);
      }).toList(),
    );
  }

  Widget _buildShopDeliverySection(
    String shopId,
    String shopName,
    List<ServiceResponseEntity> services,
    DeliveryLoaded state,
    Map<String, List<ServiceResponseEntity>> servicesByShop,
  ) {
    final selectedService = state.getSelectedServiceForShop(shopId);

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
              Text(
                shopName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        // Delivery services
        ...services.map((service) => _buildServiceOption(
          service,
          selectedService?.serviceTypeId == service.serviceTypeId,
          () => onServiceSelected(shopId, service.serviceTypeId),
        )),
        
        if (services != servicesByShop.values.last)
          const Divider(height: 1),
      ],
    );
  }

  Widget _buildServiceOption(
    ServiceResponseEntity service,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.05) : null,
          border: isSelected 
              ? const Border(left: BorderSide(color: Color(0xFF4CAF50), width: 3))
              : null,
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dự kiến: ${service.expectedDeliveryDate} ngày',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(service.totalAmount),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CurrencyFormatter {
  static String format(num value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} ₫';
  }
}