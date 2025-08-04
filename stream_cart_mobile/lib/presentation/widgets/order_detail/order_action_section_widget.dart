import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../../domain/entities/order/order_entity.dart';

// Actions (Cancel, Reorder, Contact shop)
class OrderActionSectionWidget extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onReorder;
  final VoidCallback? onContactShop;

  const OrderActionSectionWidget({
    Key? key,
    required this.order,
    this.onReorder,
    this.onContactShop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Thao tác',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final List<Widget> actions = [];

    // Cancel Order Button - chỉ hiện khi order có thể cancel
    if (_canCancelOrder()) {
      actions.add(
        _buildActionButton(
          context: context,
          title: 'Hủy đơn hàng',
          icon: Icons.cancel_outlined,
          color: Colors.red,
          onTap: () => _showCancelOrderDialog(context),
        ),
      );
    }

    // Reorder Button - cho các order đã hoàn thành hoặc hủy
    if (_canReorder()) {
      actions.add(
        _buildActionButton(
          context: context,
          title: 'Đặt lại',
          icon: Icons.refresh,
          color: Colors.blue,
          onTap: onReorder ?? () => _handleReorder(context),
        ),
      );
    }

    // Contact Shop Button - luôn có
    actions.add(
      _buildActionButton(
        context: context,
        title: 'Liên hệ shop',
        icon: Icons.chat_outlined,
        color: Colors.green,
        onTap: onContactShop ?? () => _handleContactShop(context),
      ),
    );

    // Track Order Button - cho orders đang giao
    if (_canTrackOrder()) {
      actions.add(
        _buildActionButton(
          context: context,
          title: 'Theo dõi đơn hàng',
          icon: Icons.local_shipping_outlined,
          color: Colors.orange,
          onTap: () => _handleTrackOrder(context),
        ),
      );
    }

    // Rate & Review Button - cho orders đã hoàn thành
    if (_canRateOrder()) {
      actions.add(
        _buildActionButton(
          context: context,
          title: 'Đánh giá',
          icon: Icons.star_outline,
          color: Colors.amber,
          onTap: () => _handleRateOrder(context),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions,
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logic kiểm tra có thể cancel order không
  bool _canCancelOrder() {
    // Chỉ có thể cancel khi order ở trạng thái pending hoặc confirmed
    return order.orderStatus == 0 || order.orderStatus == 1; // 0: pending, 1: confirmed
  }

  // Logic kiểm tra có thể reorder không
  bool _canReorder() {
    // Có thể reorder khi order đã hoàn thành hoặc bị hủy
    return order.orderStatus == 4 || order.orderStatus == 5; // 4: completed, 5: cancelled
  }

  // Logic kiểm tra có thể track order không
  bool _canTrackOrder() {
    // Có thể track khi order đang được chuẩn bị hoặc đang giao
    return order.orderStatus == 2 || order.orderStatus == 3; // 2: preparing, 3: shipping
  }

  // Logic kiểm tra có thể rate order không
  bool _canRateOrder() {
    // Chỉ có thể rate khi order đã hoàn thành
    return order.orderStatus == 4; // 4: completed
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn hàng'),
        content: const Text(
          'Bạn có chắc chắn muốn hủy đơn hàng này? '
          'Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleCancelOrder(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hủy đơn hàng'),
          ),
        ],
      ),
    );
  }

  void _handleCancelOrder(BuildContext context) {
    context.read<OrderBloc>().add(
      CancelOrderEvent(id: order.id),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang xử lý hủy đơn hàng...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleReorder(BuildContext context) {
    // Navigate to cart với các items từ order này
    Navigator.pushNamed(
      context,
      '/cart',
      arguments: {'reorderItems': order.items},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã thêm sản phẩm vào giỏ hàng'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleContactShop(BuildContext context) {
    // Navigate to chat hoặc contact page
    Navigator.pushNamed(
      context,
      '/contact-shop',
      arguments: {'orderId': order.id, 'shopId': order.shopId},
    );
  }

  void _handleTrackOrder(BuildContext context) {
    // Navigate to tracking page
    Navigator.pushNamed(
      context,
      '/track-order',
      arguments: order.id,
    );
  }

  void _handleRateOrder(BuildContext context) {
    // Navigate to rating page
    Navigator.pushNamed(
      context,
      '/rate-order',
      arguments: order.id,
    );
  }
}

// Alternative simple version với fixed actions
class SimpleOrderActionSectionWidget extends StatelessWidget {
  final String orderId;
  final int orderStatus;
  final VoidCallback? onCancel;
  final VoidCallback? onReorder;
  final VoidCallback? onContact;

  const SimpleOrderActionSectionWidget({
    Key? key,
    required this.orderId,
    required this.orderStatus,
    this.onCancel,
    this.onReorder,
    this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (orderStatus == 0 || orderStatus == 1) // Can cancel
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Hủy đơn'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          
          if (orderStatus == 0 || orderStatus == 1) const SizedBox(width: 12),
          
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Liên hệ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          
          if (orderStatus == 4 || orderStatus == 5) ...[
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onReorder,
                icon: const Icon(Icons.refresh),
                label: const Text('Đặt lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}