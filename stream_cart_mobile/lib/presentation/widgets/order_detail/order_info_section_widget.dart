import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../order/order_status_badge_widget.dart';

// Thông tin đơn hàng (code, date, status)
class OrderInfoSectionWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderInfoSectionWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFB0F847);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              const Text(
                'Thông tin đơn hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            'Mã đơn hàng:',
            '#${order.orderCode}',
            valueWidget: InkWell(
              onTap: () => _copyToClipboard(context, order.orderCode),
              child: Text(
                '#${order.orderCode}',
                style: const TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          _buildInfoRow(
            'Ngày đặt:',
            _formatDateTime(order.orderDate),
          ),

          const SizedBox(height: 12),

          _buildInfoRow(
            'Trạng thái đơn hàng:',
            _getStatusText(order.orderStatus),
            valueWidget: Flexible(
              child: OrderStatusBadgeWidget(status: order.orderStatus),
            ),
          ),

          const SizedBox(height: 12),

          _buildInfoRow(
            'Trạng thái thanh toán:',
            _getPaymentStatusText(order.paymentStatus),
            valueWidget: _buildPaymentStatusChip(order.paymentStatus),
          ),

          const SizedBox(height: 12),

          _buildInfoRow(
            'Tổng tiền:',
            _formatPrice(order.finalAmount),
            valueWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.18),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accent.withOpacity(0.6), width: 1),
              ),
              child: Text(
                _formatPrice(order.finalAmount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202328),
                ),
              ),
            ),
          ),

          // Thông báo tự động hoàn thành cho status 4
          if (order.orderStatus == 4) ...[
            const SizedBox(height: 16),
            _buildAutoCompleteNotice(),
          ],

          if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow('Ghi chú:', order.customerNotes!),
          ],
        ],
      ),
    );
  }

  Widget _buildAutoCompleteNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Đơn hàng sẽ tự động hoàn thành sau 3 ngày nếu bạn không xác nhận đã nhận hàng.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    TextStyle? valueStyle,
    Widget? valueWidget,
    VoidCallback? onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120, // Tăng width cho label để giảm space cho value
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: valueWidget != null 
            ? Container(
                alignment: Alignment.centerLeft,
                child: valueWidget,
              )
            : GestureDetector(
                onTap: onTap,
                child: Text(
                  value,
                  style: valueStyle ?? TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
        ),
      ],
    );
  }

  String _getStatusText(int status) {
    // Sử dụng cùng logic với OrderStatusBadgeWidget để đảm bảo tính nhất quán
    switch (status) {
      case 0: // Waiting - Chờ thanh toán
        return 'Chờ thanh toán';
      case 1: // Pending - Chờ xác nhận
        return 'Chờ xác nhận';
      case 2: // Processing - Đang chuẩn bị hàng
        return 'Đang chuẩn bị hàng';
      case 6: // Packed
        return 'Đã đóng gói';
      case 3: // Shipped - Chờ lấy hàng
        return 'Chờ lấy hàng';
      case 7: // OnDelivery - Đang giao hàng
        return 'Đang giao hàng';
      case 4: // Delivered - Đã giao hàng
        return 'Đã giao hàng';
      case 10: // Completed - Giao thành công
        return 'Giao thành công';
      case 8: // Returning
        return 'Trả hàng';
      case 9: // Refunded
        return 'Hoàn tiền';
      case 5: // Cancelled - Hủy đơn
        return 'Hủy đơn';
      default:
        return 'Không xác định';
    }
  }

  // Payment status helpers
  Widget _buildPaymentStatusChip(int paymentStatus) {
    final info = _getPaymentStatusInfo(paymentStatus);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: info['color'].withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: info['color'].withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Text(
        info['text'],
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: info['color'],
        ),
      ),
    );
  }

  Map<String, dynamic> _getPaymentStatusInfo(int status) {
    switch (status) {
      case 1:
        return {'text': 'Đã thanh toán', 'color': Colors.green};
      case 2:
        return {'text': 'Thanh toán thất bại', 'color': Colors.red};
      default:
        return {'text': 'Đang chờ thanh toán', 'color': Colors.orange};
    }
  }

  String _getPaymentStatusText(int status) {
    return _getPaymentStatusInfo(status)['text'];
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  void _copyToClipboard(BuildContext context, String text) {
    // Copy to clipboard logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép mã đơn hàng'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}