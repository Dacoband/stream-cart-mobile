import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../core/routing/app_router.dart';

class ProductGrid extends StatefulWidget {
  final List<ProductEntity>? products;
  final Map<String, String>? productImages;

  const ProductGrid({
    super.key,
    this.products,
    this.productImages,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();

}


class _ProductGridState extends State<ProductGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final products = widget.products;
    final Map<String, String> imageMap = widget.productImages ?? {};
        
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final crossAxisCount = screenWidth > 600 ? 3 : 2; 
          double aspectRatio;
          if (screenWidth < 340) {
            aspectRatio = 0.56; // rất nhỏ → cao hơn
          } else if (screenWidth < 380) {
            aspectRatio = 0.6;
          } else if (screenWidth < 420) {
            aspectRatio = 0.63;
          } else {
            aspectRatio = 0.68; 
          }
          
          if (products == null || products.isEmpty) {
            return const SizedBox.shrink();
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio.clamp(0.65, 0.8), 
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = imageMap[product.id];
              return _buildProductFromEntity(context, product, imageUrl);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductFromEntity(BuildContext context, ProductEntity product, String? imageUrl) {
    final bool hasDiscount = product.discountPrice > 0 && product.discountPrice < product.basePrice;
    final int discountPercent = hasDiscount
        ? (((product.basePrice - product.finalPrice) / product.basePrice) * 100).round().clamp(1, 99)
        : 0;
    final heroTag = 'home_product_${product.id}';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (imageUrl != null && imageUrl.isNotEmpty) {
            precacheImage(CachedNetworkImageProvider(imageUrl), context);
          }
          Navigator.pushNamed(
            context,
            AppRouter.productDetails,
            arguments: {
              'productId': product.id,
              'heroTag': heroTag,
              'imageUrl': imageUrl,
              'name': product.productName,
              'price': product.finalPrice > 0 ? product.finalPrice : product.basePrice,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                  children: [
                    // Product Image
                    Positioned.fill(
                      child: Hero(
                        tag: heroTag,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Icon(
                                      Icons.shopping_bag,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '-$discountPercent%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      _buildAdaptiveName(product.productName),
                    const SizedBox(height: 4),
                    // Price
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _formatPrice(hasDiscount ? product.finalPrice : product.basePrice),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatPrice(product.basePrice),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        'Còn lại: ${product.stockQuantity}',
                        style: TextStyle(
                          fontSize: 11,
                          color: product.stockQuantity > 10 
                              ? Colors.green 
                              : product.stockQuantity > 0 
                                  ? Colors.orange 
                                  : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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

  // Removed mock builder as real data is always provided now.

  String _formatPrice(double price) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String priceStr = price.toInt().toString();
    priceStr = priceStr.replaceAllMapped(formatter, (Match m) => '${m[1]},');
    return '${priceStr}₫';
  }

  Widget _buildAdaptiveName(String name) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final baseFont = width < 140 ? 11.0 : 12.0;
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 40),
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: baseFont,
              fontWeight: FontWeight.w500,
              height: 1.0,
              color: Colors.black87,
            ),
          ),
        );
      },
    );
  }
}
