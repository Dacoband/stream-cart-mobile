import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../widgets/cart/cart_item_widget_new.dart' as cart_widget;
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
    // Load cart data once when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartBloc = context.read<CartBloc>();
      print('CartBloc instance: ${cartBloc.hashCode}'); // Debug log
      print('CartBloc current state: ${cartBloc.state.runtimeType}'); // Debug log
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
        title: const Text('Giỏ hàng'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
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
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
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
                  padding: const EdgeInsets.all(16),
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
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'Chọn tất cả (${state.items.length} sản phẩm)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (state.hasSelectedItems) ...[
                        TextButton(
                          onPressed: () {
                            _showRemoveSelectedItemsDialog(context, state.selectedCartItemIds.toList());
                          },
                          child: const Text(
                            'Xóa đã chọn',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            context.read<CartBloc>().add(UnselectAllCartItemsEvent());
                          },
                          child: const Text('Bỏ chọn'),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return cart_widget.CartItemWidget(
                        item: item,
                        isSelected: state.selectedCartItemIds.contains(item.cartItemId),
                        onSelectionChanged: (selected) {
                          final cartBloc = context.read<CartBloc>();
                          print('CartBloc instance in selection: ${cartBloc.hashCode}'); // Debug log
                          print('Triggering selection for: ${item.cartItemId}, selected: $selected'); // Debug log
                          cartBloc.add(
                            ToggleCartItemSelectionEvent(cartItemId: item.cartItemId),
                          );
                        },
                        onQuantityChanged: (newQuantity) {
                          context.read<CartBloc>().add(
                            UpdateCartItemEvent(
                              cartItemId: item.cartItemId,
                              productId: item.productId,
                              variantId: item.variantId,
                              quantity: newQuantity,
                            ),
                          );
                        },
                        onRemove: () {
                          _showRemoveItemDialog(context, item);
                        },
                      );
                    },
                  ),
                ),
                CartSummaryWidget(
                  items: state.items,
                  totalAmount: state.totalAmount,
                  selectedItems: state.selectedItems,
                  selectedTotalAmount: state.selectedTotalAmount,
                  hasSelectedItems: state.hasSelectedItems,
                  onCheckout: () {
                    _handleCheckout(context, state);
                  },
                  onPreviewOrder: () {
                    _handlePreviewOrder(context, state);
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
          title: const Text('Xóa sản phẩm đã chọn'),
          content: Text('Bạn có muốn xóa ${selectedCartItemIds.length} sản phẩm đã chọn khỏi giỏ hàng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
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

    // Call PreviewOrder API with selected items
    final selectedCartItemIds = state.selectedCartItemIds.toList();
    context.read<CartBloc>().add(
      GetSelectedItemsPreviewEvent(selectedCartItemIds: selectedCartItemIds),
    );

    // Show preview dialog or navigate to checkout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đang xử lý ${state.selectedItems.length} sản phẩm được chọn...',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handlePreviewOrder(BuildContext context, CartLoaded state) {
    if (!state.hasSelectedItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất một sản phẩm để xem trước'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Call PreviewOrder API with selected items
    final selectedCartItemIds = state.selectedCartItemIds.toList();
    context.read<CartBloc>().add(
      GetSelectedItemsPreviewEvent(selectedCartItemIds: selectedCartItemIds),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đang lấy thông tin xem trước cho ${state.selectedItems.length} sản phẩm...',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
