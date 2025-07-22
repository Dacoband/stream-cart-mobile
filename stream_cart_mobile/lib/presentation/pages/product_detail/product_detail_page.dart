import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/product_detail/product_detail_bloc.dart';
import '../../blocs/product_detail/product_detail_event.dart';
import '../../blocs/product_detail/product_detail_state.dart';
import '../../widgets/product_detail/image_carousel.dart';
import '../../widgets/product_detail/variant_selector.dart';
import '../../widgets/product_detail/product_detail_skeleton.dart';
import '../../widgets/product_detail/add_to_cart_button.dart';
import '../../../domain/entities/product_detail_entity.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductDetailBloc>()
        ..add(LoadProductDetailEvent(productId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết sản phẩm'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Add to favorites
              },
              icon: const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {
                // TODO: Share product
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            if (state is ProductDetailLoaded && state.addToCartMessage != null) {
              if (state.addToCartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(state.addToCartMessage!),
                      ],
                    ),
                    backgroundColor: const Color(0xFF4CAF50),
                    duration: const Duration(milliseconds: 1500),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(state.addToCartMessage!)),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(milliseconds: 2000),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
            
            if (state is AddToCartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(state.message),
                    ],
                  ),
                  backgroundColor: const Color(0xFF4CAF50),
                  duration: const Duration(milliseconds: 1200),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is AddToCartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(milliseconds: 1800),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const ProductDetailSkeleton();
            }

            if (state is ProductDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Có lỗi xảy ra',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductDetailBloc>().add(
                          LoadProductDetailEvent(productId),
                        );
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }
            if (state is ProductDetailLoaded) {
              return _buildProductDetail(context, state.productDetail);
            }
            
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoaded) {
              return Container(
                height: 70, // Reduced height to match new compact design
                child: AddToCartButton(
                  product: state.productDetail,
                  selectedVariantId: state.selectedVariantId,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, ProductDetailEntity product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Images
          _buildProductImages(product),
          
          // Product Info
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Price Section
                _buildPriceSection(product),
                const SizedBox(height: 16),
                
                // Product Stats
                _buildProductStats(product),
                const SizedBox(height: 16),
                
                // Description
                _buildDescription(product),
                const SizedBox(height: 16),
                
                // Variants
                if (product.variants.isNotEmpty) ...[
                  BlocBuilder<ProductDetailBloc, ProductDetailState>(
                    builder: (context, state) {
                      final selectedVariantId = state is ProductDetailLoaded 
                          ? state.selectedVariantId 
                          : null;
                      
                      return VariantSelector(
                        variants: product.variants,
                        selectedVariantId: selectedVariantId,
                        onVariantSelected: (variantId) {
                          context.read<ProductDetailBloc>().add(
                            SelectVariantEvent(variantId),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Shop Info
                _buildShopInfo(product),
                const SizedBox(height: 16),
                
                // Product Details
                _buildProductDetails(product),
                
                // Bottom padding để tránh bị che bởi bottom navigation
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImages(ProductDetailEntity product) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        List<String> imageUrls = [];
        
        if (state is ProductDetailLoaded && state.productImages != null) {
          // Use API images if available
          imageUrls = state.productImages!.map((img) => img.imageUrl).toList();
        } else {
          // Fallback to primaryImage from product detail
          imageUrls = product.primaryImage;
        }
        
        return ImageCarousel(
          images: imageUrls,
          height: 300,
        );
      },
    );
  }

  Widget _buildPriceSection(ProductDetailEntity product) {
    return Row(
      children: [
        Text(
          '${product.finalPrice.toStringAsFixed(0)} ₫',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        if (product.discountPrice > 0) ...[
          Text(
            '${product.basePrice.toStringAsFixed(0)} ₫',
            style: const TextStyle(
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-${((product.basePrice - product.finalPrice) / product.basePrice * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProductStats(ProductDetailEntity product) {
    return Row(
      children: [
        _buildStatItem('Đã bán', '${product.quantitySold}'),
        const SizedBox(width: 16),
        _buildStatItem('Kho', '${product.stockQuantity}'),
        const SizedBox(width: 16),
        _buildStatItem('Cân nặng', product.weight),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ProductDetailEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả sản phẩm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description.isNotEmpty ? product.description : 'Không có mô tả',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildShopInfo(ProductDetailEntity product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin shop',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: product.shopLogo.isNotEmpty
                      ? NetworkImage(product.shopLogo)
                      : null,
                  child: product.shopLogo.isEmpty
                      ? const Icon(Icons.store)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.shopName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${product.shopTotalProduct} sản phẩm',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildShopStat('Đánh giá', '${product.shopRatingAverage}/5'),
                const SizedBox(width: 16),
                _buildShopStat('Phản hồi', '${(product.shopCompleteRate * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(ProductDetailEntity product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông số kỹ thuật',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Danh mục', product.categoryName),
            _buildDetailRow('Kích thước', product.dimension),
            _buildDetailRow('Cân nặng', product.weight),
            _buildDetailRow('Mã sản phẩm', product.productId),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
