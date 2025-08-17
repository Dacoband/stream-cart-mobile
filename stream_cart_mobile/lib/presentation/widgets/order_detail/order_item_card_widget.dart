// Card hiển thị từng sản phẩm

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/entities/order/order_item_entity.dart';

class OrderItemsSectionWidget extends StatelessWidget {
  final OrderEntity order;
  final Function(OrderItemEntity)? onItemTap;
  final Function(OrderItemEntity)? onWriteReviewTap;

  const OrderItemsSectionWidget({
    Key? key,
    required this.order,
    this.onItemTap,
    this.onWriteReviewTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Sản phẩm (${order.items.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          if (order.items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Không có sản phẩm',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return _buildOrderItem(context, item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemEntity item) {
    return InkWell(
      onTap: () => onItemTap?.call(item),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Hero(
              tag: 'orderItem_${item.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: (item.productImageUrl != null && item.productImageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: item.productImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image_outlined, size: 24, color: Colors.grey[400]),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_outlined, size: 24, color: Colors.grey[400]),
                        ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (item.variantId != null && item.variantId!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Phân loại: ${item.variantId}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        _formatPrice(item.unitPrice),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'x${item.quantity}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Total Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(item.totalPrice),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (onItemTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                if (onWriteReviewTap != null) ...[
                  const SizedBox(height: 6),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => onWriteReviewTap?.call(item),
                    icon: const Icon(Icons.rate_review_outlined, size: 14),
                    label: const Text('Đánh giá', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }
}

