import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../core/routing/app_router.dart';

class CategoryProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final Map<String, String> productImages;

  const CategoryProductGrid({
    super.key,
    required this.products,
    this.productImages = const {},
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return _StaggerFadeIn(
              index: index,
              child: _buildProductCard(context, product, index),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductEntity product, int index) {
    final hasDiscount = product.discountPrice > 0 && product.discountPrice < product.basePrice;
    final finalPrice = hasDiscount ? product.discountPrice : product.basePrice;
    final discountPercentage = hasDiscount 
        ? ((product.basePrice - product.discountPrice) / product.basePrice * 100).round()
        : 0;
    final heroTag = 'category_product_${product.id}';

    return GestureDetector(
      onTap: () {
        final imageUrl = productImages[product.id];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          precacheImage(CachedNetworkImageProvider(imageUrl), context);
        }
        Navigator.of(context).pushNamed(
          AppRouter.productDetails,
          arguments: {
            'productId': product.id,
            'heroTag': heroTag,
            'imageUrl': imageUrl,
            'name': product.productName,
            'price': finalPrice,
          },
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: _buildProductImage(product),
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-$discountPercentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Stock Status
                  if (product.stockQuantity <= 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Hết hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            _formatPrice(product.basePrice),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          _formatPrice(finalPrice),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Stock and Sold Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kho: ${product.stockQuantity}',
                          style: TextStyle(
                            fontSize: 10,
                            color: product.stockQuantity > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          'Đã bán: ${product.quantitySold}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    // Vietnamese format with thousand separators
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return '${formatter.format(price.round())}₫';
  }

  Widget _buildProductImage(ProductEntity product) {
    final imageUrl = productImages[product.id];
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
class _StaggerFadeIn extends StatefulWidget {
  final Widget child;
  final int index;
  const _StaggerFadeIn({required this.child, required this.index});

  @override
  State<_StaggerFadeIn> createState() => _StaggerFadeInState();
}

class _StaggerFadeInState extends State<_StaggerFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    final delay = (widget.index * 60).clamp(0, 600);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final scale = 0.96 + (0.04 * value);
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
