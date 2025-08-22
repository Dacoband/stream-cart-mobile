import 'package:flutter/material.dart';
import '../../../data/models/cart_live/cart_product_live_model.dart';

class LiveCartItemWidget extends StatelessWidget {
  final CartProductLiveModel item;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;

  const LiveCartItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.onSelectionChanged,
    this.onQuantityChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: .5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (v) => onSelectionChanged?.call(v ?? false),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: const Color(0xFF89C036),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              item.primaryImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatPrice(item.priceData.currentPrice),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDB3A34),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (item.priceData.originalPrice > item.priceData.currentPrice)
                      Text(
                        _formatPrice(item.priceData.originalPrice),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    _QuantityControl(
                      quantity: item.quantity,
                      onChanged: (q) => onQuantityChanged?.call(q),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (!item.productStatus)
                      const Text(
                        'Ngưng bán',
                        style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    if (item.stockQuantity <= 0)
                      const Text(
                        ' Hết hàng',
                        style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onRemove,
                      tooltip: 'Xóa',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double v) {
    return '${v.toStringAsFixed(0)}₫';
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const _QuantityControl({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconBtn(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text('$quantity', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          _IconBtn(
            icon: Icons.add,
            onTap: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _IconBtn({required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 16, color: onTap == null ? Colors.grey : Colors.black87),
      ),
    );
  }
}
