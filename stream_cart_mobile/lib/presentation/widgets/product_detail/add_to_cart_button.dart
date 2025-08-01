import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/products/product_detail_entity.dart';
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

class _AddToCartButtonState extends State<AddToCartButton> with TickerProviderStateMixin {
  int _quantity = 1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateButton() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16), // Tăng top padding để cân bằng
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row( // Đổi từ Column thành Row trực tiếp
          mainAxisAlignment: MainAxisAlignment.center, // Center theo chiều ngang
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: IntrinsicHeight( // Đảm bảo height đồng đều
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onPressed: _quantity > 1 ? () {
                        setState(() {
                          _quantity--;
                        });
                        _animateButton();
                      } : null,
                    ),
                    Container(
                      width: 36,
                      alignment: Alignment.center, // Center text
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF202328),
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                        _animateButton();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 6),
            
            // Add to Cart Button
            Expanded(
              flex: 3,
              child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder: (context, state) {
                  bool isLoading = false;
                  
                  if (state is AddToCartLoading) {
                    isLoading = true;
                  } else if (state is ProductDetailLoaded && state.isAddingToCart) {
                    isLoading = true;
                  }
                  
                  return AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF7B68EE),
                                const Color(0xFF9370DB),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B68EE).withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isLoading ? null : () {
                                _animateButton();
                                context.read<ProductDetailBloc>().add(
                                  AddToCartEvent(
                                    productId: widget.product.productId,
                                    variantId: widget.selectedVariantId,
                                    quantity: _quantity,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center( // Dùng Center thay vì Container alignment
                                child: isLoading 
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 3),
                                        const Text(
                                          'Thêm',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
            const SizedBox(width: 4),
            
            // Buy Now Button
            Expanded(
              flex: 2,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B35),
                      const Color(0xFFFF8E53),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _animateButton();
                      context.read<ProductDetailBloc>().add(
                        AddToCartEvent(
                          productId: widget.product.productId,
                          variantId: widget.selectedVariantId,
                          quantity: _quantity,
                        ),
                      );
                      
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushNamed(context, '/cart');
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Center( // Dùng Center thay vì Container alignment
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            'Mua',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: onPressed != null ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onPressed != null ? Colors.grey.shade200 : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: onPressed != null ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center( // Dùng Center để icon căn giữa hoàn hảo
            child: Icon(
              icon,
              size: 14,
              color: onPressed != null ? const Color(0xFF202328) : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
