import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../domain/entities/order/order_entity.dart';
import 'order_status_timeline_widget.dart';
import 'order_info_section_widget.dart';
import 'order_item_card_widget.dart';
import 'order_price_breakdown_widget.dart';
import 'shipping_info_section_widget.dart';
import 'order_action_section_widget.dart';
import '../../../core/routing/app_router.dart';
import '../../blocs/order_item/order_item_bloc.dart';
import '../../blocs/order_item/order_item_event.dart';
import '../../blocs/order_item/order_item_state.dart';

class OrderDetailViewWidget extends StatefulWidget {
  final String orderId;

  const OrderDetailViewWidget({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailViewWidget> createState() => _OrderDetailViewWidgetState();
}

class _OrderDetailViewWidgetState extends State<OrderDetailViewWidget> {
  bool _orderItemsRequested = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<OrderBloc>().add(GetOrderByIdEvent(id: widget.orderId));
  }

  Future<void> _refresh() async {
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF202328),
        foregroundColor: const Color(0xFFB0F847),
        elevation: 0,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            _load();
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderByIdLoaded) {
            return _buildContent(state.order);
          }

          if (state is OrderByCodeLoaded) {
            return _buildContent(state.order);
          }

          if (state is OrderError) {
            return _buildError(state.message);
          }

          return _buildEmpty();
        },
      ),
    );
  }

  Widget _buildContent(OrderEntity order) {
    if (!_orderItemsRequested && order.items.isEmpty) {
      _orderItemsRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrderItemBloc>().add(GetOrderItemsByOrderEvent(orderId: order.id));
        }
      });
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            OrderStatusTimelineWidget(status: order.orderStatus),
            const SizedBox(height: 8),
            OrderInfoSectionWidget(order: order),
            const SizedBox(height: 8),
            BlocBuilder<OrderItemBloc, OrderItemState>(
              builder: (context, itemState) {
                if (itemState is OrderItemLoading || itemState is OrderItemRefreshing) {
                  return _buildItemsLoadingSkeleton();
                }
                if (itemState is OrderItemsByOrderLoaded) {
                  final mergedOrder = order.copyWith(items: itemState.orderItems);
                  return OrderItemsSectionWidget(
                    order: mergedOrder,
                    onItemTap: (item) {
                      if (item.productId.isEmpty) return;
                      final heroTag = 'orderItem_${item.id}';
                      // Pre-cache image for smoother hero transition
                      if (item.productImageUrl != null && item.productImageUrl!.isNotEmpty) {
                        precacheImage(NetworkImage(item.productImageUrl!), context);
                      }
                      Navigator.of(context).pushNamed(
                        AppRouter.productDetails,
                        arguments: {
                          'productId': item.productId,
                          'heroTag': heroTag,
                          'imageUrl': item.productImageUrl,
                          'name': item.productName,
                          'price': item.unitPrice,
                        },
                      );
                    },
                    onWriteReviewTap: (item) {
                      if (item.productId.isEmpty) return;
                      Navigator.of(context).pushNamed(AppRouter.writeReview, arguments: item.productId);
                    },
                  );
                }
                if (itemState is OrderItemError) {
                  return _buildItemsError(itemState.message, order.id);
                }
                return OrderItemsSectionWidget(
                  order: order,
                  onItemTap: (item) {
                    if (item.productId.isEmpty) return;
                    final heroTag = 'orderItem_${item.id}';
                    if (item.productImageUrl != null && item.productImageUrl!.isNotEmpty) {
                      precacheImage(NetworkImage(item.productImageUrl!), context);
                    }
                    Navigator.of(context).pushNamed(
                      AppRouter.productDetails,
                      arguments: {
                        'productId': item.productId,
                        'heroTag': heroTag,
                        'imageUrl': item.productImageUrl,
                        'name': item.productName,
                        'price': item.unitPrice,
                      },
                    );
                  },
                  onWriteReviewTap: (item) {
                    if (item.productId.isEmpty) return;
                    Navigator.of(context).pushNamed(AppRouter.writeReview, arguments: item.productId);
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            OrderPriceBreakdownWidget(order: order),
            const SizedBox(height: 8),
            ShippingInfoSectionWidget(order: order),
            const SizedBox(height: 8),
            OrderActionSectionWidget(order: order),
            const SizedBox(height: 8),
            _OrderReviewsEntry(orderId: order.id),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsLoadingSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.grey[400]),
              const SizedBox(width: 8),
              const Text(
                'Sản phẩm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSkeletonLine(),
          const SizedBox(height: 12),
          _buildSkeletonLine(widthFactor: 0.7),
        ],
      ),
    );
  }

  Widget _buildSkeletonLine({double widthFactor = 1}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 16,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildItemsError(String message, String orderId) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.red),
              const SizedBox(width: 8),
              const Text(
                'Sản phẩm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Lỗi tải sản phẩm: $message', style: const TextStyle(color: Colors.red, fontSize: 12)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              context.read<OrderItemBloc>().add(GetOrderItemsByOrderEvent(orderId: orderId));
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Có lỗi xảy ra', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Không tìm thấy đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            const SizedBox(height: 8),
            const Text('Đơn hàng có thể đã bị xóa hoặc không tồn tại', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _OrderReviewsEntry extends StatelessWidget {
  final String orderId;
  const _OrderReviewsEntry({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.reviews_outlined, size: 20, color: Color(0xFF202328)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Đánh giá đơn hàng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRouter.orderReviews, arguments: orderId),
            child: const Text('Xem tất cả'),
          ),
        ],
      ),
    );
  }
}