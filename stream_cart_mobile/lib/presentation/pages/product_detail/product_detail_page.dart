import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/product_detail/product_detail_bloc.dart';
import '../../blocs/product_detail/product_detail_event.dart';
import '../../blocs/product_detail/product_detail_state.dart';
import '../../blocs/product_variants/product_variants_bloc.dart';
import '../../blocs/product_variants/product_variants_event.dart';
import '../../blocs/product_variants/product_variants_state.dart';
import '../../widgets/product_detail/image_carousel.dart';
import '../../widgets/product_detail/variant_selector.dart';
import '../../widgets/product_detail/product_detail_skeleton.dart';
import '../../widgets/product_detail/add_to_cart_button.dart';
import '../../../domain/entities/products/product_detail_entity.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProductDetailBloc>()
            ..add(LoadProductDetailEvent(widget.productId)),
        ),
        BlocProvider(
          create: (context) => getIt<ProductVariantsBloc>()
            ..add(GetProductVariantsByProductIdEvent(widget.productId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chi tiết sản phẩm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Color(0xFF202328),
          foregroundColor: Color(0xFFB0F847),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF202328),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductDetailBloc>().add(
                          LoadProductDetailEvent(widget.productId),
                        );
                        context.read<ProductVariantsBloc>().add(
                          GetProductVariantsByProductIdEvent(widget.productId),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF202328),
                        foregroundColor: Color(0xFFB0F847),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Thử lại',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
        bottomNavigationBar: BlocBuilder<ProductVariantsBloc, ProductVariantsState>(
          builder: (context, variantState) {
            return BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, detailState) {
                if (detailState is ProductDetailLoaded) {
                  String? selectedVariantId;
                  
                  // Lấy selected variant từ ProductVariantsBloc
                  if (variantState is ProductVariantsLoaded && variantState.selectedVariant != null) {
                    selectedVariantId = variantState.selectedVariant!.id;
                  }
                  
                  return Container(
                    height: 70,
                    child: AddToCartButton(
                      product: detailState.productDetail,
                      selectedVariantId: selectedVariantId,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
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
                // Product Name Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202328),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Price Section Container với Product Variants
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildPriceSectionWithVariants(product),
                ),
                const SizedBox(height: 12),
                
                // Product Stats Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildProductStats(product),
                ),
                const SizedBox(height: 12),
                
                // Description Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildDescription(product),
                ),
                const SizedBox(height: 16),
                
                // Product Variants Section
                BlocBuilder<ProductVariantsBloc, ProductVariantsState>(
                  builder: (context, state) {
                    if (state is ProductVariantsLoading) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    if (state is ProductVariantsLoaded && state.variants.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const VariantSelector(),
                      );
                    }
                    
                    if (state is ProductVariantsError) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Lỗi tải variants: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),
                
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

  Widget _buildPriceSectionWithVariants(ProductDetailEntity product) {
    return BlocBuilder<ProductVariantsBloc, ProductVariantsState>(
      builder: (context, state) {
        if (state is ProductVariantsLoaded) {
          // Nếu có variant được chọn, hiển thị giá của variant đó
          if (state.selectedVariant != null) {
            return _buildVariantPriceSection(state.selectedVariant!);
          }
          
          // Nếu có cheapest variant, hiển thị price range
          if (state.cheapestVariant != null) {
            return _buildPriceRangeSection(state.variants);
          }
        }
        
        // Fallback về giá gốc của product
        return _buildPriceSection(product);
      },
    );
  }

  Widget _buildVariantPriceSection(dynamic selectedVariant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giá phiên bản đã chọn',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '${(selectedVariant.flashSalePrice > 0 ? selectedVariant.flashSalePrice : selectedVariant.price).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 115, 175, 24),
              ),
            ),
            if (selectedVariant.flashSalePrice > 0) ...[
              const SizedBox(width: 8),
              Text(
                '${selectedVariant.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
                style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Flash Sale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Kho: ${selectedVariant.stock}',
          style: TextStyle(
            fontSize: 14,
            color: selectedVariant.stock > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(List<dynamic> variants) {
    final prices = variants.map((v) => 
      v.flashSalePrice > 0 ? v.flashSalePrice : v.price
    ).toList();
    prices.sort();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giá sản phẩm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 12),
        if (prices.first == prices.last)
          Text(
            '${prices.first.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 115, 175, 24),
            ),
          )
        else
          Text(
            '${prices.first.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫ - ${prices.last.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 115, 175, 24),
            ),
          ),
        const SizedBox(height: 4),
        const Text(
          'Chọn phiên bản để xem giá cụ thể',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildProductImages(ProductDetailEntity product) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        List<String> imageUrls = [];
        
        if (state is ProductDetailLoaded && state.productImages != null) {
          imageUrls = state.productImages!.map((img) => img.imageUrl).toList();
        } else {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giá sản phẩm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '${product.finalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 115, 175, 24),
              ),
            ),
            const SizedBox(width: 8),
            if (product.discountPrice > 0) ...[
              Text(
                '${product.basePrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
                style: const TextStyle(
                  fontSize: 14,
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
        ),
      ],
    );
  }

  Widget _buildProductStats(ProductDetailEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin bán hàng',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(child: _buildStatItem('Đã bán', '${product.quantitySold}')),
            const SizedBox(width: 14),
            Flexible(child: _buildStatItem('Kho', '${product.stockQuantity}')),
            const SizedBox(width: 14),
            Flexible(child: _buildStatItem('Cân nặng', '${product.weight}g')), 
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildDescription(ProductDetailEntity product) {
    final description = product.description.isNotEmpty ? product.description : 'Không có mô tả';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả sản phẩm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202328),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          maxLines: _isDescriptionExpanded ? null : 4,
          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        if (description.length > 200)
          const SizedBox(height: 12),
        if (description.length > 200)
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Text(
              _isDescriptionExpanded ? 'Thu gọn' : 'Xem thêm',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB0F847),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFFB0F847),
              ),
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202328),
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
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${product.shopTotalProduct} sản phẩm',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
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
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202328),
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Danh mục', product.categoryName),
            _buildDetailRow('Kích thước', product.dimension), 
            _buildDetailRow('Cân nặng', '${product.weight}g'), 
            _buildDetailRow('Chiều dài', '${product.length}cm'), 
            _buildDetailRow('Chiều rộng', '${product.width}cm'), 
            _buildDetailRow('Chiều cao', '${product.height}cm'), 
            _buildDetailRow('Mã sản phẩm', product.productId),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
  String displayValue;
  if (value is double) {
    displayValue = value.toString();
  } else if (value is int) {
    displayValue = value.toString();
  } else {
    displayValue = value.toString();
  }

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
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            displayValue,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
}
