import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/routing/app_router.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/usecases/product/get_products_by_category_usecase.dart';
import '../../../domain/usecases/product/get_product_primary_images_usecase.dart';

// Đề xuất sản phẩm trong product detail
class YouMayLikeSection extends StatelessWidget {
  final String categoryId;
  final String currentProductId;

  const YouMayLikeSection({
    super.key,
    required this.categoryId,
    required this.currentProductId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RecommendedData>(
      future: _loadRecommendations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeleton();
        }
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        final data = snapshot.data;
        if (data == null || data.products.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildContent(context, data.products, data.images);
      },
    );
  }

  Future<_RecommendedData> _loadRecommendations() async {
    final getProductsByCategory = getIt<GetProductsByCategoryUseCase>();
    final getPrimaryImages = getIt<GetProductPrimaryImagesUseCase>();

    final productsResult = await getProductsByCategory(categoryId);
    final products = productsResult.fold<List<ProductEntity>>(
      (_) => <ProductEntity>[],
      (list) => list,
    );

    final filtered = products
        .where((p) => p.id != currentProductId)
        .take(10)
        .toList();

    if (filtered.isEmpty) {
      return _RecommendedData(products: const [], images: const {});
    }

    final ids = filtered.map((e) => e.id).toList();
    final imagesResult = await getPrimaryImages(ids);
    final images = imagesResult.fold<Map<String, String>>(
      (_) => <String, String>{},
      (map) => map,
    );

    return _RecommendedData(products: filtered, images: images);
  }

  Widget _buildContent(
    BuildContext context,
    List<ProductEntity> products,
    Map<String, String> images,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Row(
            children: const [
              Icon(Icons.recommend_outlined, color: Color(0xFFB0F847), size: 20),
              SizedBox(width: 8),
              Text(
                'Sản phẩm bạn có thể thích',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202328),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = images[product.id];
              return _ProductCard(product: product, imageUrl: imageUrl);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Row(
            children: [
              Container(width: 18, height: 18, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Container(width: 180, height: 16, color: Colors.grey.shade300),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, __) => _SkeletonCard(),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: 4,
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;
  final String? imageUrl;

  const _ProductCard({required this.product, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPrice > 0 && product.discountPrice < product.basePrice;
    final discountPercent = hasDiscount
        ? (((product.basePrice - product.finalPrice) / product.basePrice) * 100).round().clamp(1, 99)
        : 0;
    final heroTag = 'recommend_${product.id}';

    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width * 0.42).clamp(150.0, 180.0);

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (imageUrl != null && imageUrl!.isNotEmpty) {
              precacheImage(CachedNetworkImageProvider(imageUrl!), context);
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
              // Image
              AspectRatio(
                aspectRatio: 16 / 11,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: heroTag,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: imageUrl != null && imageUrl!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.broken_image, size: 28, color: Colors.grey.shade400),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Icon(Icons.shopping_bag, size: 28, color: Colors.grey.shade400),
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
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            '-$discountPercent%'
                            ,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2, color: Colors.black87),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _formatPrice(hasDiscount ? product.finalPrice : product.basePrice),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatPrice(product.basePrice),
                                style: const TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String priceStr = price.toInt().toString();
    priceStr = priceStr.replaceAllMapped(formatter, (Match m) => '${m[1]},');
    return '${priceStr}₫';
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width * 0.42).clamp(150.0, 180.0);
    return SizedBox(
      width: cardWidth,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 11,
              child: Container(color: Colors.grey.shade300),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 14, width: double.infinity, color: Colors.grey.shade300),
                    Row(
                      children: [
                        Expanded(child: Container(height: 12, color: Colors.grey.shade300)),
                        const SizedBox(width: 6),
                        Container(height: 10, width: 40, color: Colors.grey.shade300),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RecommendedData {
  final List<ProductEntity> products;
  final Map<String, String> images;
  const _RecommendedData({required this.products, required this.images});
}
