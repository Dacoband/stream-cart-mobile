import 'package:flutter/material.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';

class SearchResults extends StatelessWidget {
  final String query;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final Map<String, String> productImages;
  final bool hasMoreProducts;

  const SearchResults({
    super.key,
    required this.query,
    required this.products,
    required this.categories,
    required this.productImages,
    required this.hasMoreProducts,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search summary with blue theme
          _buildSearchSummary(context),
          const SizedBox(height: 16),
          
          // Categories section
          if (categories.isNotEmpty) ...[
            _buildCategoriesSection(context),
            const SizedBox(height: 24),
          ],
          
          // Products section with responsive grid
          if (products.isNotEmpty) ...[
            _buildProductsSection(context),
          ],
          
          // No results message
          if (products.isEmpty && categories.isEmpty) ...[
            _buildNoResults(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchSummary(BuildContext context) {
    final totalResults = products.length + categories.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202328),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Color(0xFFB0F847), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tìm thấy $totalResults kết quả cho "$query"',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.category, color: Color(0xFFB0F847), size: 20),
            const SizedBox(width: 8),
            Text(
              'Danh mục (${categories.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB0F847),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...categories.map((category) => _buildCategoryItem(context, category)),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryEntity category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to category page
            print('Category tapped: ${category.categoryName}');
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.category_outlined,
                    color: const Color(0xFF4CAF50),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (category.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    // Get screen width to calculate responsive grid
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // 3 columns on tablet, 2 on phone
    final childAspectRatio = screenWidth > 600 ? 0.75 : 0.65; // Adjust aspect ratio
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shopping_bag, color: const Color(0xFFB0F847), size: 20),
            const SizedBox(width: 8),
            Text(
              'Sản phẩm (${products.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4CAF50),
              ),
            ),
            if (hasMoreProducts) ...[
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Load more products
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 30, 229, 113),
                ),
                child: const Text('Xem thêm'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl = productImages[product.id];
            return _buildProductItem(context, product, imageUrl);
          },
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, ProductEntity product, String? imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.productDetails,
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 237, 237),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB0F847).withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(255, 197, 197, 197).withOpacity(0.2),
            width: 1,
          ),
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
                  color: Colors.grey.shade50,
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
                                color: Color(0xFFB0F847),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 40,
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
                          size: 40,
                          color: Color(0xFFB0F847).withOpacity(0.5),
                        ),
                      ),
                    // Sale badge
                    if (product.isOnSale)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'SALE',
                            style: TextStyle(
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name
                    Expanded(
                      child: Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.isOnSale) ...[
                          Text(
                            '${product.basePrice.toStringAsFixed(0)}₫',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${product.finalPrice.toStringAsFixed(0)}₫',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ] else ...[
                          Text(
                            '${product.finalPrice.toStringAsFixed(0)}₫',
                            style: TextStyle(
                              color: Color.fromARGB(255, 136, 201, 40),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
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

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả nào',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thử tìm kiếm với từ khóa khác',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
