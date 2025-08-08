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
            OrderItemsSectionWidget(order: order),
            const SizedBox(height: 8),
            OrderPriceBreakdownWidget(order: order),
            const SizedBox(height: 8),
            ShippingInfoSectionWidget(order: order),
            const SizedBox(height: 8),
            OrderActionSectionWidget(order: order),
            const SizedBox(height: 24),
          ],
        ),
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