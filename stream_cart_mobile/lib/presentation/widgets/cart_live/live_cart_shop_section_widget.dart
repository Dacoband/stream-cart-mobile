import 'package:flutter/material.dart';
import '../../../data/models/cart_live/cart_item_by_shop_live_model.dart';
import 'live_cart_item_widget.dart';

class LiveCartShopSectionWidget extends StatelessWidget {
  final CartItemByShopLiveModel shopGroup;
  final Set<String> selectedIds;
  final ValueChanged<String>? onToggleSelect;
  final void Function(String cartItemId, int quantity)? onChangeQuantity;
  final void Function(String cartItemId)? onRemove;

  const LiveCartShopSectionWidget({
    super.key,
    required this.shopGroup,
    required this.selectedIds,
    this.onToggleSelect,
    this.onChangeQuantity,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey[100],
          child: Row(
            children: [
              const Icon(Icons.store, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  shopGroup.shopName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              Text('${shopGroup.products.length} sp', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ),
        ...shopGroup.products.map(
          (p) => LiveCartItemWidget(
            key: ValueKey('live_${p.cartItemId}') ,
            item: p,
            isSelected: selectedIds.contains(p.cartItemId),
            onSelectionChanged: (v) => onToggleSelect?.call(p.cartItemId),
            onQuantityChanged: (q) => onChangeQuantity?.call(p.cartItemId, q),
            onRemove: () => onRemove?.call(p.cartItemId),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
