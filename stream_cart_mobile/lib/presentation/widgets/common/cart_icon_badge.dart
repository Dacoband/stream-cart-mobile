import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';

class CartIconBadge extends StatelessWidget {
  final VoidCallback? onTap;
  final Color iconColor;
  final Color badgeColor;

  const CartIconBadge({
    super.key,
    this.onTap,
    this.iconColor = Colors.black,
    this.badgeColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    // Use the CartBloc from context instead of creating a new one
    return CartIconBadgeView(
      onTap: onTap,
      iconColor: iconColor,
      badgeColor: badgeColor,
    );
  }
}

class CartIconBadgeView extends StatelessWidget {
  final VoidCallback? onTap;
  final Color iconColor;
  final Color badgeColor;

  const CartIconBadgeView({
    super.key,
    this.onTap,
    this.iconColor = Colors.black,
    this.badgeColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;
        
        if (state is CartLoaded) {
          itemCount = state.allItems.fold<int>(0, (sum, item) => sum + item.quantity);
        }

        return IconButton(
          onPressed: onTap ?? () {
            Navigator.pushNamed(context, '/cart');
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: iconColor,
                size: 22,
              ),
              if (itemCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      itemCount > 99 ? '99+' : '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
