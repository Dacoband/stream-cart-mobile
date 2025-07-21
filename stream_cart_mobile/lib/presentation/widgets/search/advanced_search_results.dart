import 'package:flutter/material.dart';
import '../../../domain/entities/search_response_entity.dart';
import '../../../domain/entities/search_filters.dart';
import '../../../core/routing/app_router.dart';

class AdvancedSearchResults extends StatelessWidget {
  final SearchResponseEntity searchResponse;
  final SearchFilters filters;
  final List<SearchProductEntity> allProducts;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const AdvancedSearchResults({
    super.key,
    required this.searchResponse,
    required this.filters,
    required this.allProducts,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Summary
        _buildSearchSummary(context),
        const SizedBox(height: 16),
        
        // Suggested Keywords
        if (searchResponse.data.suggestedKeywords.isNotEmpty) ...[
          _buildSuggestedKeywords(context),
          const SizedBox(height: 16),
        ],

        // Products Grid
        Expanded(
          child: _buildProductsGrid(context),
        ),
      ],
    );
  }

  Widget _buildSearchSummary(BuildContext context) {
    final data = searchResponse.data;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            searchResponse.message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.search,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Từ khóa: "${data.searchTerm}"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Text(
                '${data.searchTimeMs.toStringAsFixed(1)}ms',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          if (filters.hasActiveFilters) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${filters.activeFiltersCount} bộ lọc đang áp dụng',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedKeywords(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Có thể bạn đang tìm:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: searchResponse.data.suggestedKeywords.map((keyword) {
            return ActionChip(
              label: Text(keyword),
              onPressed: () {
                // TODO: Implement search with suggested keyword
                print('Search with keyword: $keyword');
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    if (allProducts.isEmpty) {
      return const Center(
        child: Text('Không có sản phẩm nào'),
      );
    }

    return Column(
      children: [
        // Products count and sorting info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${allProducts.length} sản phẩm',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Sắp xếp: ${SortOption.fromValue(filters.sortBy).displayName}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Products Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: allProducts.length + (isLoadingMore ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= allProducts.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final product = allProducts[index];
              return _buildProductItem(context, product);
            },
          ),
        ),

        // Load More Button
        if (searchResponse.data.products.hasNext && !isLoadingMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: onLoadMore,
              child: const Text('Tải thêm sản phẩm'),
            ),
          ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, SearchProductEntity product) {
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
                    if (product.primaryImageUrl != null && product.primaryImageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.primaryImageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
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
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'SALE ${product.discountPercentage.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    // Stock indicator
                    if (!product.inStock)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Hết hàng',
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name (with highlighting if available)
                    Text(
                      product.highlightedName ?? product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    
                    // Rating and Review Count
                    if (product.averageRating > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 4),
                    
                    // Price
                    if (product.isOnSale) ...[
                      Text(
                        '${product.basePrice.toStringAsFixed(0)}₫',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${product.finalPrice.toStringAsFixed(0)}₫',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '${product.finalPrice.toStringAsFixed(0)}₫',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                    
                    // Shop info
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.shopName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
}
