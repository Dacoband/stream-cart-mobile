import 'package:flutter/material.dart';
import '../../../domain/entities/flash_sale_entity.dart';
import '../../../domain/entities/product_entity.dart';

class FlashSaleItemCard extends StatelessWidget {
  final FlashSaleEntity flashSale;
  final ProductEntity product;
  final String? imageUrl; // Add imageUrl parameter

  const FlashSaleItemCard({
    super.key,
    required this.flashSale,
    required this.product,
    this.imageUrl, // Optional image URL
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive width and height calculation based on screen size
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Improved responsive calculations
        final cardWidth = screenWidth * 0.42; // Increased to 42% for better content space
        final minWidth = 140.0; // Increased minimum width
        final maxWidth = 180.0; // Increased maximum width
        final finalWidth = cardWidth.clamp(minWidth, maxWidth);
        
        // Dynamic height based on screen size
        double cardHeight;
        if (screenHeight > 800) {
          cardHeight = 200.0; // Large screens
        } else if (screenHeight > 700) {
          cardHeight = 180.0; // Medium screens
        } else if (screenHeight > 600) {
          cardHeight = 160.0; // Smaller screens
        } else {
          cardHeight = 140.0; // Very small screens
        }
        
        return SizedBox(
          width: finalWidth,
          height: cardHeight,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(cardHeight),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8), // Increased padding for better spacing
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildProductName(),
                          _buildPriceSection(),
                          Column(
                            children: [
                              _buildProgressBar(),
                              const SizedBox(height: 4),
                              _buildSoldInfo(),
                            ],
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
      },
    );
  }

  Widget _buildProductImage(double cardHeight) {
    // Calculate image height as 45% of card height
    final imageHeight = (cardHeight * 0.45).clamp(60.0, 100.0);
    
    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 24,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          // Discount badge
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-${flashSale.getDiscountPercentage(product.basePrice).toInt()}%',
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
    );
  }

  Widget _buildProductName() {
    return Flexible(
      child: Text(
        product.productName,
        style: const TextStyle(
          fontSize: 12, // Increased from 9 to 12 for better readability
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: Colors.black87,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${flashSale.flashSalePrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
          style: TextStyle(
            fontSize: 13, // Increased from 9 to 13
            fontWeight: FontWeight.bold,
            color: Colors.red[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (product.basePrice > flashSale.flashSalePrice) ...[
          const SizedBox(height: 2),
          Text(
            '${product.basePrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
            style: const TextStyle(
              fontSize: 10, // Increased from 7 to 10
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildProgressBar() {
    final soldPercentage = flashSale.soldPercentage / 100;
    
    return Container(
      height: 4, // Increased from 3 to 4
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey[300],
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: soldPercentage.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                Colors.orange[400]!,
                Colors.red[400]!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoldInfo() {
    final remaining = flashSale.quantityAvailable;
    
    return Text(
      'Còn $remaining sản phẩm',
      style: const TextStyle(
        fontSize: 10, // Increased from 7 to 10
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
