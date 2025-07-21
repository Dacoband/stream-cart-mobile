import 'package:equatable/equatable.dart';

class SearchFilters extends Equatable {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? shopId;
  final String sortBy;
  final bool inStockOnly;
  final int? minRating;
  final bool onSaleOnly;
  final int pageNumber;
  final int pageSize;

  const SearchFilters({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.shopId,
    this.sortBy = 'relevance',
    this.inStockOnly = false,
    this.minRating,
    this.onSaleOnly = false,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  SearchFilters copyWith({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? sortBy,
    bool? inStockOnly,
    int? minRating,
    bool? onSaleOnly,
    int? pageNumber,
    int? pageSize,
  }) {
    return SearchFilters(
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      shopId: shopId ?? this.shopId,
      sortBy: sortBy ?? this.sortBy,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      minRating: minRating ?? this.minRating,
      onSaleOnly: onSaleOnly ?? this.onSaleOnly,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  SearchFilters clearFilters() {
    return const SearchFilters();
  }

  bool get hasActiveFilters {
    return categoryId != null ||
           minPrice != null ||
           maxPrice != null ||
           shopId != null ||
           sortBy != 'relevance' ||
           inStockOnly ||
           minRating != null ||
           onSaleOnly;
  }

  int get activeFiltersCount {
    int count = 0;
    if (categoryId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (shopId != null) count++;
    if (sortBy != 'relevance') count++;
    if (inStockOnly) count++;
    if (minRating != null) count++;
    if (onSaleOnly) count++;
    return count;
  }

  @override
  List<Object?> get props => [
        categoryId,
        minPrice,
        maxPrice,
        shopId,
        sortBy,
        inStockOnly,
        minRating,
        onSaleOnly,
        pageNumber,
        pageSize,
      ];
}

enum SortOption {
  relevance('relevance', 'Liên quan'),
  priceAsc('price_asc', 'Giá thấp đến cao'),
  priceDesc('price_desc', 'Giá cao đến thấp'),
  newest('newest', 'Mới nhất'),
  bestSelling('best_selling', 'Bán chạy'),
  topRated('top_rated', 'Đánh giá cao');

  const SortOption(this.value, this.displayName);
  
  final String value;
  final String displayName;

  static SortOption fromValue(String value) {
    return SortOption.values.firstWhere(
      (option) => option.value == value,
      orElse: () => SortOption.relevance,
    );
  }
}
