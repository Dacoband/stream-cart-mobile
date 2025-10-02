import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/cart_live/cart_live_bloc.dart';
import '../../blocs/cart_live/cart_live_event.dart';

import '../../../core/routing/app_router.dart';
import '../../../domain/entities/livestream/livestream_product_entity.dart';
import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_state.dart';

class LiveStreamProductsBottomSheet extends StatelessWidget {
  final LiveStreamBloc bloc;
  final String liveStreamId;
  final BuildContext rootContext;
  final VoidCallback reopenBottomSheet;

  const LiveStreamProductsBottomSheet({
    super.key,
    required this.bloc,
    required this.liveStreamId,
    required this.rootContext,
    required this.reopenBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: bloc),
        BlocProvider(create: (_) => getIt<CartLiveBloc>()..add(LoadCartLiveEvent(liveStreamId))),
      ],
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (_, controller) {
          final colorScheme = Theme.of(context).colorScheme;
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF202328),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Sản phẩm trong livestream',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB0F847),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Đóng',
                          icon: const Icon(Icons.close, color: Color(0xFFB0F847)),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<LiveStreamBloc, LiveStreamState>(
                      builder: (c, state) {
                        if (state is LiveStreamLoaded) {
                          if (state.isLoadingProducts && state.products.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state.products.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text('Chưa có sản phẩm', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            );
                          }
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final maxW = constraints.maxWidth;
                              final crossAxisCount = maxW >= 900
                                  ? 4
                                  : maxW >= 600
                                      ? 3
                                      : 2;
                              const spacing = 12.0;
                              final totalSpacing = spacing * (crossAxisCount - 1);
                              final itemWidth = (maxW - totalSpacing) / crossAxisCount;
                              const innerHPadding = 16.0;
                              const verticalPadding = 16.0; 
                              const belowImage = 8.0;
                              const titleHeight = 22.0;
                              const gapToPrice = 6.0;
                              const priceRow = 28.0;
                              const origPriceRow = 18.0;
                              const metaRow = 18.0;
                              const fudge = 10.0;
                              final imageHeight = (itemWidth - innerHPadding).clamp(0, itemWidth);
                              final mainExtent = verticalPadding + imageHeight + belowImage + titleHeight + gapToPrice + priceRow + origPriceRow + metaRow + fudge;

                return CustomScrollView(
                                controller: controller,
                                slivers: [
                                  if (state.pinnedProducts.isNotEmpty) ...[
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.push_pin, size: 16, color: Color(0xFFB0F847)),
                                            SizedBox(width: 6),
                                            Text('Sản phẩm được ghim', style: TextStyle(fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SliverGrid(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: spacing,
                                        mainAxisSpacing: spacing,
                                        mainAxisExtent: mainExtent,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, i) {
                                          final p = state.pinnedProducts[i];
                                          return _ProductCard(
                                            product: p,
                                            priceColor: colorScheme.primary,
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              await Navigator.pushNamed(
                                                rootContext,
                                                AppRouter.productDetails,
                                                arguments: {
                                                  'productId': p.productId,
                                                  'imageUrl': p.productImageUrl.isNotEmpty ? p.productImageUrl : null,
                                                  'name': p.productName,
                                                  'price': p.price,
                                                },
                                              );
                                              if (!rootContext.mounted) return;
                                              reopenBottomSheet();
                                            },
                                            onAddToCart: () {
                                              context.read<CartLiveBloc>().add(AddToCartLiveEvent(
                                                    livestreamId: liveStreamId,
                                                    livestreamProductId: p.id,
                                                    quantity: 1,
                                                  ));
                                              ScaffoldMessenger.of(rootContext).showSnackBar(
                                                const SnackBar(content: Text('Đang thêm vào giỏ live...')),
                                              );
                                            },
                                          );
                                        },
                                        childCount: state.pinnedProducts.length,
                                      ),
                                    ),
                                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                                  ],
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.list_alt, size: 16, color: Color(0xFFB0F847)),
                                          SizedBox(width: 6),
                                          Text('Tất cả sản phẩm', style: TextStyle(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverGrid(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: spacing,
                                      mainAxisSpacing: spacing,
                                      mainAxisExtent: mainExtent,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, i) {
                                        final p = state.products[i];
                                        return _ProductCard(
                                          product: p,
                                          priceColor: colorScheme.primary,
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await Navigator.pushNamed(
                                              rootContext,
                                              AppRouter.productDetails,
                                              arguments: {
                                                'productId': p.productId,
                                                'imageUrl': p.productImageUrl.isNotEmpty ? p.productImageUrl : null,
                                                'name': p.productName,
                                                'price': p.price,
                                              },
                                            );
                                            if (!rootContext.mounted) return;
                                            reopenBottomSheet();
                                          },
                                          onAddToCart: () {
                                            context.read<CartLiveBloc>().add(AddToCartLiveEvent(
                                                  livestreamId: liveStreamId,
                                                  livestreamProductId: p.id,
                                                  quantity: 1,
                                                ));
                                            ScaffoldMessenger.of(rootContext).showSnackBar(
                                              const SnackBar(content: Text('Đang thêm vào giỏ live...')),
                                            );
                                          },
                                        );
                                      },
                                      childCount: state.products.length,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (state is LiveStreamLoading || state is LiveStreamInitial) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is LiveStreamError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final LiveStreamProductEntity product;
  final VoidCallback onTap;
  final Color priceColor;
  final VoidCallback? onAddToCart;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.priceColor,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final surface = Theme.of(context).colorScheme.surface;

    return Material(
      color: surface,
      elevation: 0,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: product.productImageUrl.isNotEmpty
                      ? Image.network(
                          product.productImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade200, child: const Icon(Icons.image, size: 28)),
                        )
                      : Container(color: Colors.grey.shade200, child: const Icon(Icons.image, size: 28)),
                ),
              ),
              const SizedBox(height: 8),
        Builder(builder: (_) {
                final variant = (product.variantName ?? '').trim();
                final nameToShow = variant.isNotEmpty ? variant : product.productName;
                return Text(
                  nameToShow,
          maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                );
              }),
        const SizedBox(height: 4),
              if (product.originalPrice > 0 && product.originalPrice > product.price)
                Text(
                  CurrencyFormatter.formatVND(product.originalPrice),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    CurrencyFormatter.formatVND(product.price),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: priceColor,
                    ),
                  ),
                  const Spacer(),
                  if (onAddToCart != null)
                    InkWell(
                      onTap: onAddToCart,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: priceColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: const Icon(Icons.add_shopping_cart, size: 16),
                      ),
                    ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: priceColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.chevron_right, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Builder(builder: (_) {
                final meta = <String>[];
                if (product.sku.trim().isNotEmpty) meta.add('SKU: ${product.sku}');
                final stock = product.productStock;
                meta.add(stock > 0 ? 'Còn: $stock' : 'Hết hàng');
                return Text(
                  meta.join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
