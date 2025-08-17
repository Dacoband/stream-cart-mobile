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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: statusInfo['textColor'],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(int? status) {
    switch (status) {
      case 0: // Pending/Chờ xác nhận
        return {
          'text': 'Chờ xác nhận',
          'backgroundColor': Colors.orange[50],
          'borderColor': Colors.orange[200],
          'textColor': Colors.orange[700],
        };
      
      case 1: // Confirmed/Đang chuẩn bị
        return {
          'text': 'Đang chuẩn bị',
          'backgroundColor': Colors.blue[50],
          'borderColor': Colors.blue[200],
          'textColor': Colors.blue[700],
        };
      
      case 2: // Shipping/Đang giao
        return {
          'text': 'Đang giao',
          'backgroundColor': Colors.purple[50],
          'borderColor': Colors.purple[200],
          'textColor': Colors.purple[700],
        };
      
      case 3: // Delivered/Hoàn thành
        return {
          'text': 'Hoàn thành',
          'backgroundColor': Colors.green[50],
          'borderColor': Colors.green[200],
          'textColor': Colors.green[700],
        };
      
      case 4: // Cancelled/Đã hủy
        return {
          'text': 'Đã hủy',
          'backgroundColor': Colors.red[50],
          'borderColor': Colors.red[200],
          'textColor': Colors.red[700],
        };
      
      case 5: // Returned/Trả hàng
        return {
          'text': 'Trả hàng',
          'backgroundColor': Colors.grey[50],
          'borderColor': Colors.grey[300],
          'textColor': Colors.grey[700],
        };
      
      case 6: // Refunded/Hoàn tiền
        return {
          'text': 'Hoàn tiền',
          'backgroundColor': Colors.teal[50],
          'borderColor': Colors.teal[200],
          'textColor': Colors.teal[700],
        };
      
      default: // Unknown status
        return {
          'text': 'Không xác định',
          'backgroundColor': Colors.grey[100],
          'borderColor': Colors.grey[300],
          'textColor': Colors.grey[600],
        };
    }
  }
}

// Extension để dễ sử dụng
extension OrderStatusExtension on int? {
  String get statusText {
    switch (this) {
      case 0:
        return 'Chờ xác nhận';
      case 1:
        return 'Đang chuẩn bị';
      case 2:
        return 'Đang giao';
      case 3:
        return 'Hoàn thành';
      case 4:
        return 'Đã hủy';
      case 5:
        return 'Trả hàng';
      case 6:
        return 'Hoàn tiền';
      default:
        return 'Không xác định';
    }
  }

  Color get statusColor {
    switch (this) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      case 5:
        return Colors.grey;
      case 6:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  bool get canCancel {
    return this == 0 || this == 1; // Chỉ có thể hủy khi chờ xác nhận hoặc đang chuẩn bị
  }

  bool get canReorder {
    return this == 3 || this == 4; // Có thể đặt lại khi hoàn thành hoặc đã hủy
  }

  bool get isCompleted {
    return this == 3; // Hoàn thành
  }

  bool get isCancelled {
    return this == 4; // Đã hủy
  }

  bool get isActive {
    return this != null && this! >= 0 && this! <= 2; // Đang trong quá trình xử lý
  }
}