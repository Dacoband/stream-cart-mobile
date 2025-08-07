import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../widgets/cart/cart_item_widget.dart';
import '../../widgets/cart/cart_summary_widget.dart';
import '../../widgets/cart/empty_cart_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartBloc = context.read<CartBloc>();
      cartBloc.add(LoadCartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CartView();
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Giỏ hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        backgroundColor: Color(0xFF202328),
        foregroundColor: Color(0xFFB0F847),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.allItems.isNotEmpty) { 
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear') {
                      _showClearCartDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Xóa tất cả'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CartItemAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CartItemUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blue,
              ),
            );
          } else if (state is CartItemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (state is CartCleared) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blue,
              ),
            );
          } else if (state is CartPreviewOrderLoaded) { 
            Navigator.pushNamed(
              context, 
              '/checkout',
              arguments: state.previewData,
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CartLoaded) {
            if (state.allItems.isEmpty) { 
              return EmptyCartWidget(
                onContinueShopping: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              );
            }

            return Column(
              children: [
                // Select All Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: state.isAllSelected,
                        onChanged: (value) {
                          if (value == true) {
                            context.read<CartBloc>().add(SelectAllCartItemsEvent());
                          } else {
                            context.read<CartBloc>().add(UnselectAllCartItemsEvent());
                          }
                        },
                        activeColor: Color.fromARGB(255, 137, 192, 54),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Expanded(
                        child: Text(
                          'Chọn tất cả (${state.allItems.length} sản phẩm)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (state.hasSelectedItems) ...[
                        TextButton(
                          onPressed: () {
                            _showRemoveSelectedItemsDialog(context, state.selectedCartItemIds.toList());
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Xóa',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CartBloc>().add(UnselectAllCartItemsEvent());
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Bỏ chọn',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartData.cartItemByShop.length,
                    itemBuilder: (context, shopIndex) {
                      final shop = state.cartData.cartItemByShop[shopIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shop Header
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.grey[100],
                            child: Row(
                              children: [
                                Icon(Icons.store, size: 20, color: Colors.black87),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    shop.shopName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${shop.numberOfProduct} sản phẩm',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Shop Products
                          ...shop.products.map((item) {
                            return CartItemWidget(
                              item: item,
                              isSelected: state.selectedCartItemIds.contains(item.cartItemId),
                              onSelectionChanged: (selected) {
                                context.read<CartBloc>().add(
                                  ToggleCartItemSelectionEvent(cartItemId: item.cartItemId),
                                );
                              },
                              onQuantityChanged: (newQuantity) {
                                context.read<CartBloc>().add(
                                  UpdateCartItemEvent(
                                    cartItemId: item.cartItemId,
                                    quantity: newQuantity,
                                  ),
                                );
                              },
                              onRemove: () {
                                _showRemoveItemDialog(context, item);
                              },
                            );
                          }).toList(),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ),
                CartSummaryWidget(
                  items: state.allItems, 
                  totalAmount: state.totalAmount,
                  selectedItems: state.selectedItems,
                  selectedTotalAmount: state.selectedTotalAmount,
                  hasSelectedItems: state.hasSelectedItems,
                  onCheckout: () {
                    _handleCheckout(context, state);
                  },
                ),
              ],
            );
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Có lỗi xảy ra',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.message.contains('đăng nhập')) ...[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Đăng nhập'),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(LoadCartEvent());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ],
              ),
            );
          }

          return EmptyCartWidget(
            onContinueShopping: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          );
        },
      ),
    );
  }

  void _showRemoveSelectedItemsDialog(BuildContext context, List<String> selectedCartItemIds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xóa sản phẩm đã chọn',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Bạn có muốn xóa ${selectedCartItemIds.length} sản phẩm đã chọn khỏi giỏ hàng?',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartBloc>().add(
                  RemoveSelectedCartItemsEvent(
                    cartItemIds: selectedCartItemIds,
                  ),
                );
              },
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveItemDialog(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa sản phẩm'),
          content: const Text('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartBloc>().add(
                  RemoveCartItemEvent(
                    cartItemId: item.cartItemId,
                  ),
                );
              },
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa tất cả'),
          content: const Text('Bạn có muốn xóa tất cả sản phẩm khỏi giỏ hàng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartBloc>().add(ClearCartEvent());
              },
              child: const Text(
                'Xóa tất cả',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleCheckout(BuildContext context, CartLoaded state) {
    if (!state.hasSelectedItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất một sản phẩm để thanh toán'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get preview order data first, then navigate to checkout
    final selectedCartItemIds = state.selectedCartItemIds.toList();
    context.read<CartBloc>().add(
      GetSelectedItemsPreviewEvent(selectedCartItemIds: selectedCartItemIds),
    );
    
    // Show loading message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang chuẩn bị thông tin thanh toán...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}