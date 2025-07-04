import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/product_entity.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductEntity>? products;
  
  const ProductGrid({
    super.key,
    this.products,
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: products?.isNotEmpty == true 
            ? products!.length 
            : _mockProducts.length,
        itemBuilder: (context, index) {
          if (products?.isNotEmpty == true) {
            final product = products![index];
            return _buildProductFromEntity(context, product);
          } else {
            final product = _mockProducts[index];
            return _buildProductFromMock(context, product);
          }
        },
      ),
    );
  }

  Widget _buildProductFromEntity(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to product detail
        print('Product tapped: ${product.productName}');
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Row(
                      children: [
                        Text(
                          _formatPrice(product.discountPrice > 0 && product.discountPrice < product.basePrice 
                              ? product.discountPrice 
                              : product.basePrice),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        if (product.discountPrice > 0 && product.discountPrice < product.basePrice) ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _formatPrice(product.basePrice),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Stock quantity
                    Text(
                      'Còn lại: ${product.stockQuantity}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.stockQuantity > 10 
                            ? Colors.green 
                            : product.stockQuantity > 0 
                                ? Colors.orange 
                                : Colors.red,
                        fontWeight: FontWeight.w500,
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Row(
                      children: [
                        Text(
                          _formatPrice(product['price'].toDouble()),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        if (product['originalPrice'] != null) ...[
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _formatPrice(product['originalPrice'].toDouble()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Stock quantity
                    Text(
                      'Còn lại: ${product['stockQuantity']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product['stockQuantity'] > 10 
                            ? Colors.green 
                            : product['stockQuantity'] > 0 
                                ? Colors.orange 
                                : Colors.red,
                        fontWeight: FontWeight.w500,
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
