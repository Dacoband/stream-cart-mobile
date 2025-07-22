import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/routing/app_router.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_state.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductEntity>? products;
  final Map<String, String>? productImages;
  
  const ProductGrid({
    super.key,
    this.products,
    this.productImages,
  });

  // Mock products data for fallback
  static const List<Map<String, dynamic>> _mockProducts = [
    {
      'id': '1',
      'name': 'iPhone 15 Pro Max',
      'price': 29990000,
      'originalPrice': 34990000,
      'rating': 4.8,
      'reviewCount': 256,
      'imageColor': Colors.blue,
      'isOnSale': true,
      'stockQuantity': 50,
    },
    {
      'id': '2',
      'name': 'Samsung Galaxy S24 Ultra',
      'price': 27990000,
      'originalPrice': null,
      'rating': 4.7,
      'reviewCount': 189,
      'imageColor': Colors.green,
      'isOnSale': false,
      'stockQuantity': 30,
    },
    {
      'id': '3',
      'name': 'MacBook Air M3',
      'price': 31990000,
      'originalPrice': 35990000,
      'rating': 4.9,
      'reviewCount': 324,
      'imageColor': Colors.purple,
      'isOnSale': true,
      'stockQuantity': 15,
    },
    {
      'id': '4',
      'name': 'iPad Pro 12.9',
      'price': 26990000,
      'originalPrice': null,
      'rating': 4.6,
      'reviewCount': 152,
      'imageColor': Colors.orange,
      'isOnSale': false,
      'stockQuantity': 25,
    },
    {
      'id': '5',
      'name': 'AirPods Pro',
      'price': 6990000,
      'originalPrice': 7990000,
      'rating': 4.8,
      'reviewCount': 892,
      'imageColor': Colors.cyan,
      'isOnSale': true,
      'stockQuantity': 100,
    },
    {
      'id': '6',
      'name': 'Apple Watch Series 9',
      'price': 9990000,
      'originalPrice': null,
      'rating': 4.7,
      'reviewCount': 445,
      'imageColor': Colors.red,
      'isOnSale': false,
      'stockQuantity': 40,
    },
  ];
  @override
  Widget build(BuildContext context) {
    // Use productImages from parameter, fallback to empty map
    final Map<String, String> imageMap = productImages ?? {};
    
    // Debug: Print productImages map
    print('🖼️ ProductGrid - productImages map: ${imageMap.keys.toList()}');
    print('🖼️ ProductGrid - productImages count: ${imageMap.length}');
    if (products?.isNotEmpty == true) {
      print('🖼️ ProductGrid - products count: ${products!.length}');
      for (var product in products!) {
        print('🖼️ Product ID: ${product.id} -> imageUrl: ${imageMap[product.id]}');
      }
    }
        
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive grid based on screen width
          final screenWidth = constraints.maxWidth;
          final crossAxisCount = screenWidth > 600 ? 3 : 2; // 3 columns on tablets, 2 on phones
          final itemWidth = (screenWidth - (12 * (crossAxisCount - 1))) / crossAxisCount;
          final aspectRatio = itemWidth / (itemWidth * 1.35); // Dynamic aspect ratio
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio.clamp(0.65, 0.8), // Clamp aspect ratio for safety
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: products?.isNotEmpty == true 
                ? products!.length 
                : _mockProducts.length,
            itemBuilder: (context, index) {
              if (products?.isNotEmpty == true) {
                final product = products![index];
                // Lấy URL hình ảnh từ productImages map
                final imageUrl = imageMap[product.id];
                return _buildProductFromEntity(context, product, imageUrl);
              } else {
                final product = _mockProducts[index];
                return _buildProductFromMock(context, product);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildProductFromEntity(BuildContext context, ProductEntity product, String? imageUrl) {
    // Debug: Print image URL information
    print('🖼️ Product ${product.productName} - ID: ${product.id}, imageUrl: $imageUrl');
    
    return GestureDetector(
      onTap: () {
        print('Product tapped: ${product.productName} - ID: ${product.id}');
        Navigator.pushNamed(
          context,
          AppRouter.productDetails,
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    // Product Image
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey.shade400,
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    // Sale badge
                    if (product.discountPrice > 0 && product.discountPrice < product.basePrice)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'SALE',
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
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Flexible(
                      child: Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13, // Slightly smaller font
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2, // Reduced line height
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _formatPrice(product.discountPrice > 0 && product.discountPrice < product.basePrice 
                                  ? product.discountPrice 
                                  : product.basePrice),
                              style: const TextStyle(
                                fontSize: 13, // Slightly smaller font
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (product.discountPrice > 0 && product.discountPrice < product.basePrice) ...[
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatPrice(product.basePrice),
                                style: TextStyle(
                                  fontSize: 11, // Smaller font for crossed price
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
                    // Stock quantity
                    Flexible(
                      child: Text(
                        'Còn lại: ${product.stockQuantity}',
                        style: TextStyle(
                          fontSize: 11, // Smaller font for stock
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

  Widget _buildProductFromMock(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to product detail
        print('Product tapped: ${product['name']}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (product['imageColor'] as Color).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: product['imageColor'] as Color,
                      ),
                    ),
                    // Sale badge
                    if (product['isOnSale'] == true)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'SALE',
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
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Flexible(
                      child: Text(
                        product['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13, // Slightly smaller font
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2, // Reduced line height
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _formatPrice(product['price'].toDouble()),
                              style: const TextStyle(
                                fontSize: 13, // Slightly smaller font
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (product['originalPrice'] != null) ...[
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _formatPrice(product['originalPrice'].toDouble()),
                                style: TextStyle(
                                  fontSize: 11, // Smaller font for crossed price
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
                    // Stock quantity
                    Flexible(
                      child: Text(
                        'Còn lại: ${product['stockQuantity']}',
                        style: TextStyle(
                          fontSize: 11, // Smaller font for stock
                          color: product['stockQuantity'] > 10 
                              ? Colors.green 
                              : product['stockQuantity'] > 0 
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

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M₫';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(1).replaceAll('.0', '')}K₫';
    } else {
      return '${price.toInt()}₫';
    }
  }
}
