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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          title: 'Hủy đơn',
          icon: Icons.cancel_outlined,
          color: Colors.red,
          onTap: () => _showCancelOrderDialog(context),
        ),
      );
    }

    // Confirm Received Button - chỉ hiện khi order status = 4 (Đã giao hàng)
    if (_canConfirmReceived()) {
      actions.add(
        _buildActionButton(
          context: context,
          title: 'Xác nhận đã nhận hàng',
          icon: Icons.done_all_outlined,
          color: Colors.green[700]!,
          onTap: () => _showConfirmReceivedDialog(context),
        ),
      );
    }

    // Reorder Button - cho các order đã hoàn thành hoặc hủy
    if (_canReorder()) {
      actions.add(
        _buildActionButton(
          context: context,
          title: 'Mua lại',
          icon: Icons.shopping_cart_outlined,
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
          title: 'Theo dõi đơn',
          icon: Icons.local_shipping_outlined,
          color: Colors.purple,
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
          icon: Icons.star_rate_outlined,
          color: Colors.amber[800]!,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
    return order.orderStatus == 0 || order.orderStatus == 1;
  }

  // Logic kiểm tra có thể confirm received không
  bool _canConfirmReceived() {
    return order.orderStatus == 4; // Đã giao hàng
  }

  // Logic kiểm tra có thể reorder không
  bool _canReorder() {
    return order.orderStatus == 4 || order.orderStatus == 5;
  }

  // Logic kiểm tra có thể track order không
  bool _canTrackOrder() {
    return order.orderStatus == 2 || order.orderStatus == 3;
  }

  // Logic kiểm tra có thể rate order không
  bool _canRateOrder() {
    return order.orderStatus == 10; // Chỉ cho phép đánh giá khi đã hoàn thành
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _handleCancelOrder(context); // Use original context
            },
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );
  }

  void _showConfirmReceivedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận đã nhận hàng'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn đã nhận được hàng và hài lòng với sản phẩm?'),
            SizedBox(height: 8),
            Text(
              'Lưu ý: Sau khi xác nhận, bạn không thể hoàn trả sản phẩm.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Chưa nhận'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _handleConfirmReceived(context); // Use original context, not dialogContext
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Đã nhận hàng'),
          ),
        ],
      ),
    );
  }

  void _handleCancelOrder(BuildContext context) {
    context.read<OrderBloc>().add(CancelOrderEvent(id: order.id));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi yêu cầu hủy đơn'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleConfirmReceived(BuildContext context) {
    // Cập nhật status từ 4 (Đã giao hàng) -> 10 (Thành công)
    context.read<OrderBloc>().add(
      UpdateOrderStatusEvent(
        orderId: order.id,
        status: 10,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xác nhận nhận hàng thành công'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleReorder(BuildContext context) {
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
    Navigator.pushNamed(
      context,
      '/contact-shop',
      arguments: {'orderId': order.id, 'shopId': order.shopId},
    );
  }

  void _handleTrackOrder(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/track-order',
      arguments: order.id,
    );
  }

  void _handleRateOrder(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (orderStatus == 0 || orderStatus == 1)
            ElevatedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Hủy đơn'),
            ),
          ElevatedButton.icon(
            onPressed: onReorder,
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Mua lại'),
          ),
          OutlinedButton.icon(
            onPressed: onContact,
            icon: const Icon(Icons.chat_outlined),
            label: const Text('Liên hệ'),
          ),
        ],
      ),
    );
  }
}