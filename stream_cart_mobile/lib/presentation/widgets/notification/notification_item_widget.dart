import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/notification/notification_entity.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notification.isRead ? 1 : 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _getTypeDisplayName(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _getTypeColor(),
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(notification.created),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    IconButton(
                      icon: const Icon(Icons.mark_email_read_outlined),
                      onPressed: onMarkAsRead,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: notification.isRead ? Colors.grey[700] : Colors.black87,
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                ),
              ),
              if (notification.linkUrl != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Nhấn để xem chi tiết',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'FlashSale':
        iconData = Icons.flash_on;
        iconColor = Colors.orange;
        break;
      case 'Order':
        iconData = Icons.shopping_bag;
        iconColor = Colors.blue;
        break;
      case 'Product':
        iconData = Icons.inventory;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  String _getTypeDisplayName() {
    switch (notification.type) {
      case 'FlashSale':
        return 'Flash Sale';
      case 'Order':
        return 'Đơn hàng';
      case 'Product':
        return 'Sản phẩm';
      default:
        return 'Thông báo';
    }
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case 'FlashSale':
        return Colors.orange;
      case 'Order':
        return Colors.blue;
      case 'Product':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Hôm qua ${DateFormat('HH:mm').format(dateTime)}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else {
        return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
