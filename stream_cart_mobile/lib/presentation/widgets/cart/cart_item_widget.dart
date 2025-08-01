import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/cart/cart_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;

  const CartItemWidget({
    super.key,
    required this.item,
    this.onRemove,
    this.onQuantityChanged,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                onSelectionChanged?.call(value ?? false);
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            
            // Product Image Placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.primaryImage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.primaryImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 16),
            
            // Product Details
            Expanded(
              flex: 3, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName.isNotEmpty ? item.productName : 'Tên sản phẩm',
                    style: const TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Price display
                  Wrap( 
                    children: [
                      Text(
                        _formatPrice(item.currentPrice),
                        style: const TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      if (item.originalPrice > item.currentPrice) ...[
                        const SizedBox(width: 8),
                        Text(
                          _formatPrice(item.originalPrice),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Stock status
                  if (item.stockQuantity > 0)
                    Text(
                      'Còn lại: ${item.stockQuantity}',
                      style: TextStyle(
                        fontSize: 12,
                        color: item.stockQuantity > 10 ? Colors.green : Colors.orange,
                      ),
                    )
                  else
                    Text(
                      'Hết hàng',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            
            // Quantity Controls - Compact version
            Flexible(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: item.quantity > 1 
                          ? () => onQuantityChanged?.call(item.quantity - 1)
                          : null,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Container(
                        width: 40,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => onQuantityChanged?.call(item.quantity + 1),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Remove Button
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.red,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
