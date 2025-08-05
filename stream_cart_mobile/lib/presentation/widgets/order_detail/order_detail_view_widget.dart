import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/domain/entities/address/address_entity.dart';
import 'package:stream_cart_mobile/domain/entities/order/create_order_request_entity.dart';
import 'package:stream_cart_mobile/domain/entities/order/shipping_address_entity.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../domain/entities/order/order_entity.dart';
import 'order_action_section_widget.dart';
import 'order_info_section_widget.dart';
import 'order_items_section_widget.dart';
import 'order_summary_section_widget.dart';
import 'order_timeline_widget.dart';
import '../common/loading_widget.dart';
import '../common/error_widget.dart';

// Main layout for the order detail view
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
  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  void _loadOrderDetail() {
    context.read<OrderBloc>().add(
      GetOrderByIdEvent(id: widget.orderId),
    );
  }

  Future<void> _refreshOrderDetail() async {
    _loadOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Reload order after successful operation
            _loadOrderDetail();
          }
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OrderDetailLoaded) {
            return _buildOrderDetailContent(state.order);
          }

          if (state is OrderError) {
            return _buildErrorView(state.message);
          }

          return _buildEmptyView();
        },
      ),
    );
  }

  Widget _buildOrderDetailContent(OrderEntity order) {
    return RefreshIndicator(
      onRefresh: _refreshOrderDetail,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Timeline
            OrderTimelineWidget(
              order: order,
            ),

            const SizedBox(height: 8),

            // Order Basic Info (ID, Date, Status)
            OrderInfoSectionWidget(
              order: order,
            ),

            const SizedBox(height: 8),

            // Order Items List
            OrderItemsSectionWidget(
              order: order,
              onItemTap: (item) {
                Navigator.pushNamed(
                  context,
                  '/order-item-detail',
                  arguments: {
                    'orderId': order.id,
                    'itemId': item.id,
                  },
                );
              },
            ),

            const SizedBox(height: 8),

            // Order Summary (Pricing breakdown)
            OrderSummarySectionWidget(
              order: order,
            ),

            const SizedBox(height: 8),

            // Delivery Information
            _buildDeliveryInfoSection(order),

            const SizedBox(height: 8),

            // Payment Information  
            _buildPaymentInfoSection(order),

            const SizedBox(height: 8),

            // Action Buttons (Cancel, Reorder, Contact)
            OrderActionSectionWidget(
              order: order,
              onReorder: () => _handleReorder(order),
              onContactShop: () => _handleContactShop(order),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoSection(OrderEntity order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              const Text(
                'Thông tin giao hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Người nhận:', order.shippingAddress.fullName),
          const SizedBox(height: 8),
          _buildInfoRow('Số điện thoại:', order.shippingAddress.phone),
          const SizedBox(height: 8),
          _buildInfoRow('Địa chỉ:', order.shippingAddress.addressLine1),
          const SizedBox(height: 8),
          _buildInfoRow('Ghi chú:', order.customerNotes ?? 'Không có ghi chú'),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoSection(OrderEntity order, CreateOrderRequestEntity? paymentMethod) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Row(
            children: [
              Icon(
                Icons.payment_outlined,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              const Text(
                'Thông tin thanh toán',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Phương thức:', _getPaymentMethodText(paymentMethod?.paymentMethod)),
          const SizedBox(height: 8),
          _buildInfoRow('Trạng thái:', _getPaymentStatusText(order.paymentStatus)),
          if (order.orderStatus == 1) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Thời gian thanh toán:', _formatDateTime(order.orderDate)),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadOrderDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy đơn hàng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đơn hàng có thể đã bị xóa hoặc không tồn tại',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleReorder(OrderEntity order) {
    // Add all items from this order to cart
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

  void _handleContactShop(OrderEntity order) {
    // Navigate to contact/chat page
    Navigator.pushNamed(
      context,
      '/contact-shop',
      arguments: {
        'orderId': order.id,
        'shopId': order.shopId,
      },
    );
  }

  String _getPaymentMethodText(String? paymentMethod) {
    switch (paymentMethod) {
      case 'cash':
        return 'Tiền mặt';
      case 'bank_transfer':
        return 'Chuyển khoản';
      default:
        return 'Không xác định';
    }
  }

  String _getPaymentStatusText(int? paymentStatus) {
    switch (paymentStatus) {
      case 0:
        return 'Chưa thanh toán';
      case 1:
        return 'Đã thanh toán';
      case 2:
        return 'Thanh toán thất bại';
      case 3:
        return 'Hoàn tiền';
      default:
        return 'Không xác định';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Simplified version for quick implementation
class SimpleOrderDetailViewWidget extends StatelessWidget {
  final String orderId;

  const SimpleOrderDetailViewWidget({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OrderDetailLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Basic order info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đơn hàng #${state.order.code}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Tổng tiền: ${state.order.totalAmount}đ'),
                        Text('Trạng thái: ${_getStatusText(state.order.status)}'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Action buttons
                OrderActionSectionWidget(order: state.order),
              ],
            ),
          );
        }

        return const Center(
          child: Text('Không thể tải thông tin đơn hàng'),
        );
      },
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0: return 'Chờ xác nhận';
      case 1: return 'Đã xác nhận';
      case 2: return 'Đang chuẩn bị';
      case 3: return 'Đang giao';
      case 4: return 'Hoàn thành';
      case 5: return 'Đã hủy';
      default: return 'Không xác định';
    }
  }
}