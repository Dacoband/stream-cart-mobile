import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/order/order_entity.dart';

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
            'Trạng thái:',
            _getStatusText(order.orderStatus),
            valueWidget: _buildStatusChip(order.orderStatus),
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

          if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow('Ghi chú:', order.customerNotes!),
          ],
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
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: valueWidget ?? GestureDetector(
            onTap: onTap,
            child: Text(
              value,
              style: valueStyle ?? TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(int status) {
    final statusInfo = _getStatusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo['color'].withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusInfo['color'].withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Text(
        statusInfo['text'],
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: statusInfo['color'],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(int status) {
    switch (status) {
      case 0:
        return {'text': 'Chờ xác nhận', 'color': Colors.orange};
      case 1:
        return {'text': 'Đã xác nhận', 'color': Colors.blue};
      case 2:
        return {'text': 'Đang chuẩn bị', 'color': Colors.purple};
      case 3:
        return {'text': 'Đang giao', 'color': Colors.indigo};
      case 4:
        return {'text': 'Hoàn thành', 'color': Colors.green};
      case 5:
        return {'text': 'Đã hủy', 'color': Colors.red};
      default:
        return {'text': 'Không xác định', 'color': Colors.grey};
    }
  }

  String _getStatusText(int status) {
    return _getStatusInfo(status)['text'];
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