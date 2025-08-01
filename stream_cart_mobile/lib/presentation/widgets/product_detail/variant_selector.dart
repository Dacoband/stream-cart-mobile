import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/products/product_variants_entity.dart';
import '../../blocs/product_variants/product_variants_bloc.dart';
import '../../blocs/product_variants/product_variants_event.dart';
import '../../blocs/product_variants/product_variants_state.dart';

class VariantSelector extends StatelessWidget {
  const VariantSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductVariantsBloc, ProductVariantsState>(
      builder: (context, state) {
        if (state is ProductVariantsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is ProductVariantsLoaded && state.variants.isNotEmpty) {
          return _buildVariantSelector(context, state);
        }
        
        if (state is ProductVariantsError) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Lỗi tải variants: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildVariantSelector(BuildContext context, ProductVariantsLoaded state) {
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
          children: state.variants.map((variant) {
            final isSelected = state.selectedVariant?.id == variant.id;
            final isOutOfStock = variant.stock <= 0;
            
            return GestureDetector(
              onTap: isOutOfStock ? null : () {
                context.read<ProductVariantsBloc>().add(
                  SelectVariantEvent(variant.id),
                );
              },
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
                          '${(variant.flashSalePrice > 0 ? variant.flashSalePrice : variant.price).toStringAsFixed(0)} ₫',
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
                            child: const Text(
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
                      'SKU: ${variant.sku}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white70
                            : (isOutOfStock ? Colors.grey : Colors.grey.shade600),
                      ),
                    ),
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
        if (state.selectedVariant != null) ...[
          const SizedBox(height: 12),
          _buildSelectedVariantInfo(context, state.selectedVariant!),
        ],
      ],
    );
  }

  Widget _buildSelectedVariantInfo(BuildContext context, ProductVariantEntity selectedVariant) {
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
                  'SKU: ${selectedVariant.sku} - ${(selectedVariant.flashSalePrice > 0 ? selectedVariant.flashSalePrice : selectedVariant.price).toStringAsFixed(0)} ₫ (Kho: ${selectedVariant.stock})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<ProductVariantsBloc>().add(
                const ClearSelectedVariantEvent(),
              );
            },
            child: Icon(
              Icons.close,
              color: Colors.blue.shade600,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
