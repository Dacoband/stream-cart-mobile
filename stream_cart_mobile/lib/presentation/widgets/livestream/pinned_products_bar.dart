import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_state.dart';
import '../../../core/routing/app_router.dart';

class PinnedProductsBar extends StatelessWidget {
  const PinnedProductsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamBloc, LiveStreamState>(
      builder: (context, state) {
        if (state is! LiveStreamLoaded) return const SizedBox.shrink();
        final pinned = state.pinnedProducts;
        if (pinned.isEmpty && !state.isLoadingPinned) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF15181C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2E33), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.push_pin, size: 16, color: Color(0xFFB0F847)),
                  const SizedBox(width: 6),
                  const Text(
                    'Sản phẩm đã ghim',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if (state.isLoadingPinned)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (pinned.isEmpty)
                const Text('Chưa có sản phẩm ghim', style: TextStyle(color: Colors.white70, fontSize: 12))
              else
                SizedBox(
                  height: 112,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pinned.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (ctx, i) {
                      final p = pinned[i];
                      return _PinnedCard(
                        imageUrl: p.productImageUrl,
                        title: (p.variantName ?? '').trim().isNotEmpty ? p.variantName!.trim() : p.productName,
                        price: p.price,
                        originalPrice: p.originalPrice,
                        sku: p.sku,
                        stock: p.productStock,
                        onTap: () async {
                          await Navigator.of(context).pushNamed(
                            AppRouter.productDetails,
                            arguments: {
                              'productId': p.productId,
                              'imageUrl': p.productImageUrl.isNotEmpty ? p.productImageUrl : null,
                              'name': p.productName,
                              'price': p.price,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PinnedCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double originalPrice;
  final String sku;
  final int stock;
  final VoidCallback onTap;

  const _PinnedCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.sku,
    required this.stock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF202328),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2E33)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 28),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, size: 28),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${price.toStringAsFixed(0)} đ',
                        style: const TextStyle(color: Color(0xFFB0F847), fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      if (originalPrice > 0 && originalPrice > price)
                        Text(
                          '${originalPrice.toStringAsFixed(0)} đ',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Builder(builder: (_) {
                    final meta = <String>[];
                    if (sku.trim().isNotEmpty) meta.add('SKU: $sku');
                    meta.add(stock > 0 ? 'Còn: $stock' : 'Hết hàng');
                    return Text(
                      meta.join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
