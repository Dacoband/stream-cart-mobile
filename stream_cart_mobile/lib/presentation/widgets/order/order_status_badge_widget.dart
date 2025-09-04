import 'package:flutter/material.dart';

// Badge hiển thị trạng thái
class OrderStatusBadgeWidget extends StatelessWidget {
  final int? status;

  const OrderStatusBadgeWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo['backgroundColor'],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusInfo['borderColor'],
          width: 1,
        ),
      ),
      child: Text(
        statusInfo['text'],
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: statusInfo['textColor'],
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(int? status) {
    // Backend enum mapping (ref):
    // 0 Waiting, 1 Pending, 2 Processing, 3 Shipped, 4 Delivered,
    // 5 Cancelled, 6 Packed, 7 OnDelivery, 8 Returning, 9 Refunded, 10 Completed
    switch (status) {
      case 0: // Waiting - Chờ thanh toán
        return _build('Chờ thanh toán', Colors.yellow);
      case 1: // Pending - Chờ xác nhận
        return _build('Chờ xác nhận', Colors.orange);
      case 2: // Processing - Đang chuẩn bị hàng
        return _build('Đang chuẩn bị hàng', Colors.blue);
      case 6: // Packed
        return _build('Đã đóng gói', Colors.indigo);
      case 3: // Shipped - Chờ lấy hàng
        return _build('Chờ lấy hàng', Colors.deepPurple);
      case 7: // OnDelivery - Đang giao hàng
        return _build('Đang giao hàng', Colors.purple);
      case 4: // Delivered - Đã giao hàng
        return _build('Đã giao hàng', Colors.green);
      case 10: // Completed - Giao thành công
        return _build('Giao thành công', Colors.green.shade700);
      case 8: // Returning
        return _build('Trả hàng', Colors.brown);
      case 9: // Refunded
        return _build('Hoàn tiền', Colors.teal);
      case 5: // Cancelled - Hủy đơn
        return _build('Hủy đơn', Colors.red);
      default:
        return _build('Không xác định', Colors.grey);
    }
  }

  Map<String, dynamic> _build(String text, Color base) {
    final Color textColor;
    if (base is MaterialColor) {
      textColor = base[700]!;
    } else {
      textColor = base;
    }
    return {
      'text': text,
      'backgroundColor': base.withOpacity(0.06),
      'borderColor': base.withOpacity(0.35),
      'textColor': textColor,
    };
  }
}

// Extension để dễ sử dụng
extension OrderStatusExtension on int? {
  String get statusText => OrderStatusBadgeWidget(status: this)._getStatusInfo(this)['text'];

  Color get statusColor {
    switch (this) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blueGrey;
      case 2:
        return Colors.blue;
      case 6:
        return Colors.indigo;
      case 3:
        return Colors.deepPurple;
      case 7:
        return Colors.purple;
      case 4:
        return Colors.green;
      case 10:
        return Colors.green.shade700;
      case 8:
        return Colors.brown;
      case 9:
        return Colors.teal;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool get canCancel => this != null && (this == 0 || this == 1 || this == 2); // Cho phép hủy trước khi đóng gói / gửi

  bool get canReorder => this == 4 || this == 5 || this == 9 || this == 10; // Giao, huỷ, hoàn tiền, hoàn thành

  bool get isCompleted => this == 4 || this == 10; // Thành công (status 4 và 10)

  bool get isCancelled => this == 5; // Đã hủy

  bool get isActive => this != null && {0,1,2,6,3,7}.contains(this); // đang trong pipeline fulfilment
}