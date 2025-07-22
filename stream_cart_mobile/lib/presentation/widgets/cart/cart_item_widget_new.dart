import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/cart_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final bool isSelected;
  final Function(bool)? onSelectionChanged;
  final Function(int)? onQuantityChanged;
  final VoidCallback? onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onSelectionChanged,
    this.onQuantityChanged,
    this.onRemove,
  });

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Top row: Checkbox + Product info + Remove button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    print('Checkbox clicked: $value for item: ${item.cartItemId}');
                    onSelectionChanged?.call(value ?? false);
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                
                // Product Image
                Container(
                  width: 60,
                  height: 60,
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
                                size: 30,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(width: 12),
                
                // Product Details
                Expanded(
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
                      Text(
                        _formatPrice(item.currentPrice),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      if (item.originalPrice > item.currentPrice)
                        Text(
                          _formatPrice(item.originalPrice),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(height: 4),
                      
                      // Stock status
                      if (item.stockQuantity > 0)
                        Text(
                          'Còn lại: ${item.stockQuantity}',
                          style: TextStyle(
                            fontSize: 11,
                            color: item.stockQuantity > 10 ? Colors.green : Colors.orange,
                          ),
                        )
                      else
                        Text(
                          'Hết hàng',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                          ),
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
            
            // Bottom row: Quantity Controls
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: item.quantity > 1 
                    ? () => onQuantityChanged?.call(item.quantity - 1)
                    : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.remove, size: 18),
                  ),
                ),
                Container(
                  width: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => onQuantityChanged?.call(item.quantity + 1),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.add, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
