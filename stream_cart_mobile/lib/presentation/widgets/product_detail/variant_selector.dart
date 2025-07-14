import 'package:flutter/material.dart';
import '../../../domain/entities/product_detail_entity.dart';

class VariantSelector extends StatelessWidget {
  final List<ProductVariant> variants;
  final String? selectedVariantId;
  final Function(String variantId) onVariantSelected;

  const VariantSelector({
    super.key,
    required this.variants,
    required this.selectedVariantId,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phiên bản',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: variants.map((variant) {
            final isSelected = variant.variantId == selectedVariantId;
            final isOutOfStock = variant.stock <= 0;
            
            return GestureDetector(
              onTap: isOutOfStock ? null : () => onVariantSelected(variant.variantId),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : (isOutOfStock ? Colors.grey.shade200 : Colors.white),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : (isOutOfStock ? Colors.grey.shade300 : Colors.grey.shade400),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${variant.price.toStringAsFixed(0)} ₫',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected
                                ? Colors.white
                                : (isOutOfStock ? Colors.grey : Colors.black87),
                          ),
                        ),
                        if (variant.flashSalePrice > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Flash Sale',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kho: ${variant.stock}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white70
                            : (isOutOfStock ? Colors.grey : Colors.grey.shade600),
                      ),
                    ),
                    if (isOutOfStock) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Hết hàng',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (selectedVariantId != null) ...[
          const SizedBox(height: 12),
          _buildSelectedVariantInfo(),
        ],
      ],
    );
  }

  Widget _buildSelectedVariantInfo() {
    final selectedVariant = variants.firstWhere(
      (variant) => variant.variantId == selectedVariantId,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đã chọn phiên bản',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${selectedVariant.price.toStringAsFixed(0)} ₫ (Kho: ${selectedVariant.stock})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
