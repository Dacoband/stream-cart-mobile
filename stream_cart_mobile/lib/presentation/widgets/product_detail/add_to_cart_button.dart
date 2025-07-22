import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product_detail_entity.dart';
import '../../blocs/product_detail/product_detail_bloc.dart';
import '../../blocs/product_detail/product_detail_event.dart';
import '../../blocs/product_detail/product_detail_state.dart';

class AddToCartButton extends StatefulWidget {
  final ProductDetailEntity product;
  final String? selectedVariantId;
  final int quantity;

  const AddToCartButton({
    super.key,
    required this.product,
    this.selectedVariantId,
    this.quantity = 1,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity Selector - made more compact
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () {
                      setState(() {
                        _quantity--;
                      });
                    } : null,
                    icon: const Icon(Icons.remove, size: 18),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                    icon: const Icon(Icons.add, size: 18),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Add to Cart Button
            Expanded(
              flex: 3, // Give more space to add to cart
              child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder: (context, state) {
                  bool isLoading = false;
                  
                  if (state is AddToCartLoading) {
                    isLoading = true;
                  } else if (state is ProductDetailLoaded && state.isAddingToCart) {
                    isLoading = true;
                  }
                  
                  return ElevatedButton(
                    onPressed: isLoading ? null : () {
                      context.read<ProductDetailBloc>().add(
                        AddToCartEvent(
                          productId: widget.product.productId,
                          variantId: widget.selectedVariantId,
                          quantity: _quantity,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: isLoading 
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_cart, size: 18),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Thêm vào giỏ',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            
            // Buy Now Button
            Expanded(
              flex: 2, // Less space for buy now
              child: ElevatedButton(
                onPressed: () {
                  // First add to cart, then navigate to cart or checkout
                  context.read<ProductDetailBloc>().add(
                    AddToCartEvent(
                      productId: widget.product.productId,
                      variantId: widget.selectedVariantId,
                      quantity: _quantity,
                    ),
                  );
                  
                  // Navigate to cart after a short delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushNamed(context, '/cart');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Mua ngay',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
