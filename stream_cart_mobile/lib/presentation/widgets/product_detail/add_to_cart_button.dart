import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/products/product_detail_entity.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/cart/cart_event.dart' as cart_events;
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/common/auth_guard.dart' show showLoginRequiredDialog;

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

  bool _requireLogin({required String message}) {
    final authState = context.read<AuthBloc>().state;
    final loggedIn = authState is AuthSuccess || authState is AuthAuthenticated;
    if (!loggedIn) {
      showLoginRequiredDialog(context, message: message);
      return true; // indicates blocked due to auth
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16), 
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: IntrinsicHeight(
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
                      alignment: Alignment.center,
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
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  bool isLoading = cartState is CartLoading;
                  
                  return AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B68EE), Color(0xFF9370DB)],
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
                                if (_requireLogin(message: 'Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng')) {
                                  return;
                                }
                                _animateButton();
                                context.read<CartBloc>().add(
                                  cart_events.AddToCartEvent(
                                    productId: widget.product.productId,
                                    variantId: widget.selectedVariantId ?? '',
                                    quantity: _quantity,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text('Đã thêm vào giỏ hàng'),
                                      ],
                                    ),
                                    backgroundColor: Color(0xFF4CAF50),
                                    duration: Duration(milliseconds: 1500),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
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
                                      children: const [
                                        Icon(Icons.shopping_cart_outlined, size: 14, color: Colors.white),
                                        SizedBox(width: 3),
                                        Text('Thêm', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
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
                      if (_requireLogin(message: 'Vui lòng đăng nhập để mua hàng')) {
                        return;
                      }
                      _animateButton();
                      context.read<CartBloc>().add(
                        cart_events.AddToCartEvent(
                          productId: widget.product.productId,
                          variantId: widget.selectedVariantId ?? '',
                          quantity: _quantity,
                        ),
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushNamed(context, '/cart');
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.bolt, size: 12, color: Colors.white),
                          SizedBox(width: 2),
                          Text('Mua', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
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
          child: Center(
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
