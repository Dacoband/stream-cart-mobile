import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart_live/cart_live_bloc.dart';
import '../../blocs/cart_live/cart_live_event.dart';
import '../../blocs/cart_live/cart_live_state.dart';
import '../../widgets/cart_live/live_cart_shop_section_widget.dart';
import '../../widgets/cart_live/live_cart_summary_widget.dart';
import '../../widgets/cart_live/empty_live_cart_widget.dart';
import '../../blocs/cart_live/preview_order_live_bloc.dart';
import '../../../core/routing/app_router.dart';

class LiveCartPage extends StatefulWidget {
  final String livestreamId;
  const LiveCartPage({super.key, required this.livestreamId});

  @override
  State<LiveCartPage> createState() => _LiveCartPageState();
}

class _LiveCartPageState extends State<LiveCartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartLiveBloc>().add(LoadCartLiveEvent(widget.livestreamId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ live',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF202328),
        foregroundColor: const Color(0xFFB0F847),
        actions: [
          BlocBuilder<CartLiveBloc, CartLiveState>(
            builder: (context, state) {
              if (state is CartLiveLoaded || state is CartLiveUpdated) {
                final cart = state is CartLiveLoaded ? state.cart : (state as CartLiveUpdated).cart;
                if (cart.listCartItem.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reload',
                    onPressed: () => context.read<CartLiveBloc>().add(LoadCartLiveEvent(widget.livestreamId)),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartLiveBloc, CartLiveState>(
            listener: (context, state) {
              if (state is CartLiveError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                );
              }
            },
          ),
          BlocListener<PreviewOrderLiveBloc, PreviewOrderLiveState>(
            listener: (context, pState) {
              if (pState is PreviewOrderLiveLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (pState is PreviewOrderLiveLoaded) {
                if (Navigator.canPop(context)) Navigator.pop(context); 
                final preview = pState.data.toPreviewOrderDataEntity();
                Navigator.pushNamed(
                  context,
                  AppRouter.checkout,
                  arguments: {
                    'preview': preview,
                    'liveCartItemIds': pState.data.listCartItem
                        .expand((s) => s.products.map((p) => p.cartItemId))
                        .where((id) => (context.read<CartLiveBloc>().state is CartLiveLoaded)
                            ? (context.read<CartLiveBloc>().state as CartLiveLoaded).selectedCartItemIds.contains(id)
                            : (context.read<CartLiveBloc>().state is CartLiveUpdated)
                                ? (context.read<CartLiveBloc>().state as CartLiveUpdated).selectedCartItemIds.contains(id)
                                : true)
                        .toList(),
                    'livestreamId': widget.livestreamId,
                  },
                );
              } else if (pState is PreviewOrderLiveError) {
                if (Navigator.canPop(context)) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(pState.message), backgroundColor: Colors.redAccent),
                );
              }
            },
          ),
        ],
  child: BlocBuilder<CartLiveBloc, CartLiveState>(
  builder: (context, state) {
          if (state is CartLiveLoading || state is CartLiveActionInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLiveCleared) {
            return EmptyLiveCartWidget(
              onBackToLive: () => Navigator.pop(context),
            );
          }

          if (state is CartLiveLoaded || state is CartLiveUpdated) {
            final cart = state is CartLiveLoaded ? state.cart : (state as CartLiveUpdated).cart;
            final selected = state is CartLiveLoaded
                ? state.selectedCartItemIds
                : (state as CartLiveUpdated).selectedCartItemIds;
            if (cart.listCartItem.isEmpty) {
              return EmptyLiveCartWidget(onBackToLive: () => Navigator.pop(context));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.listCartItem.length,
                    itemBuilder: (context, index) {
                      final shopGroup = cart.listCartItem[index];
                      return LiveCartShopSectionWidget(
                        shopGroup: shopGroup,
                        selectedIds: selected,
                        onToggleSelect: (id) => context
                            .read<CartLiveBloc>()
                            .add(ToggleSelectCartLiveItemEvent(id)),
                        onChangeQuantity: (id, q) => context
                            .read<CartLiveBloc>()
                            .add(UpdateCartLiveItemQuantityEvent(cartItemId: id, quantity: q)),
                        onRemove: (id) => context
                            .read<CartLiveBloc>()
                            .add(RemoveCartLiveItemEvent(id)),
                      );
                    },
                  ),
                ),
                LiveCartSummaryWidget(
                  cart: cart,
                  selectedIds: selected,
                  onCheckout: () {
                    final ids = selected.toList();
                    if (ids.isEmpty) return;
                    context.read<PreviewOrderLiveBloc>().add(RequestPreviewOrderLiveEvent(ids));
                  },
                  onClear: () => context
                      .read<CartLiveBloc>()
                      .add(ClearCartLiveEvent(widget.livestreamId)),
                ),
              ],
            );
          }

          if (state is CartLiveError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(state.message, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<CartLiveBloc>()
                        .add(LoadCartLiveEvent(widget.livestreamId)),
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          return EmptyLiveCartWidget(onBackToLive: () => Navigator.pop(context));
        },
        ),
      ),
    );
  }
}
