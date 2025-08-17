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
    const Color primaryGreen = Color.fromARGB(255, 116, 168, 38); 
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Phiên bản',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF202328),
              ),
            ),
            const Spacer(),
            Text(
              '${state.variants.length} tùy chọn',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.variants.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final variant = state.variants[index];
            final isSelected = state.selectedVariant?.id == variant.id;
            final isOutOfStock = variant.stock <= 0;
            
            return GestureDetector(
              onTap: isOutOfStock ? null : () {
                context.read<ProductVariantsBloc>().add(
                  SelectVariantEvent(variant.id),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryGreen.withOpacity(0.1)
                      : (isOutOfStock ? Colors.grey.shade100 : Colors.white),
                  border: Border.all(
                    color: isSelected
                        ? primaryGreen
                        : (isOutOfStock ? Colors.grey.shade300 : Colors.grey.shade300),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Row(
                  children: [
                    // Price Section
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${(variant.flashSalePrice > 0 ? variant.flashSalePrice : variant.price).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isSelected
                                      ? primaryGreen
                                      : (isOutOfStock ? Colors.grey : Colors.black87),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '₫',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: isSelected
                                      ? primaryGreen
                                      : (isOutOfStock ? Colors.grey : Colors.black54),
                                ),
                              ),
                            ],
                          ),
                          if (variant.flashSalePrice > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${variant.price.toStringAsFixed(0)}₫',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'SALE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // SKU & Stock Section
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variant.sku,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? primaryGreen
                                  : (isOutOfStock ? Colors.grey : Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_outlined,
                                size: 14,
                                color: isOutOfStock ? Colors.red : Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isOutOfStock ? 'Hết hàng' : '${variant.stock} có sẵn',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isOutOfStock ? Colors.red : Colors.green.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Selection Indicator
                    if (isSelected)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    else
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isOutOfStock ? Colors.grey.shade400 : Colors.grey.shade500,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        if (state.selectedVariant != null) ...[
          const SizedBox(height: 16),
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
                    fontSize: 13,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w400,
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
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
