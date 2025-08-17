import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/entities/order/order_item_entity.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/order_item/order_item_bloc.dart';
import '../../blocs/order_item/order_item_event.dart';
import '../../blocs/order_item/order_item_state.dart';
import 'order_status_badge_widget.dart';

// Card hiển thị order summary
class OrderCardWidget extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;

  const OrderCardWidget({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderItemBloc>()
        ..add(GetOrderItemsByOrderEvent(orderId: order.id)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: order.orderStatus.statusColor.withOpacity(0.6),
              width: 3,
            ),
          ),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
                _buildContent(context),
                const Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Shop icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.store_outlined,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          // Order code and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: order.orderStatus.statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Đơn hàng #${order.orderCode}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(order.orderDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Status + chevron
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderStatusBadgeWidget(status: order.orderStatus),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<OrderItemBloc, OrderItemState>(
        builder: (context, state) {
          Widget child;
          if (state is OrderItemsByOrderLoaded && state.orderItems.isNotEmpty) {
            final items = state.orderItems;
            child = Column(
              key: ValueKey('loaded_${order.id}'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.take(2).map((item) => _buildOrderItemRow(item)).toList(),
                if (items.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+${items.length - 2} sản phẩm khác',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is OrderItemError) {
            child = Text(
              'Không thể tải sản phẩm',
              key: ValueKey('error_${order.id}'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[400],
                fontStyle: FontStyle.italic,
              ),
            );
          } else {
            // Loading placeholder
            child = Column(
              key: ValueKey('loading_${order.id}'),
              children: [
                _buildItemPlaceholder(),
                const SizedBox(height: 10),
                _buildItemPlaceholder(),
              ],
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildItemPlaceholder() {
    return Row(
      children: [
        // Image placeholder
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        // Text placeholders
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 10,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Price placeholder
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 10,
              width: 28,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 12,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderItemRow(OrderItemEntity orderItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Product image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              image: orderItem.productImageUrl != null && orderItem.productImageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(orderItem.productImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (orderItem.productImageUrl == null || orderItem.productImageUrl!.isEmpty)
                ? Icon(
                    Icons.image_outlined,
                    size: 22,
                    color: Colors.grey[400],
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderItem.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Quantity and price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x${orderItem.quantity}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _formatVnd(orderItem.unitPrice),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Total items
          BlocBuilder<OrderItemBloc, OrderItemState>(
            builder: (context, state) {
              final count = (state is OrderItemsByOrderLoaded)
                  ? state.orderItems.length
                  : 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count sản phẩm',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _formatVnd(order.finalAmount),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return 'Hôm nay ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Hôm qua ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatVnd(double? amount) {
    final value = amount ?? 0;
    final s = value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$s ₫';
  }
}