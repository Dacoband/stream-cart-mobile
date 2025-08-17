import 'package:equatable/equatable.dart';

class SearchResponseEntity extends Equatable {
  final bool success;
  final String message;
  final SearchDataEntity data;
  final List<String> errors;

  const SearchResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  @override
  List<Object?> get props => [success, message, data, errors];
}

class SearchDataEntity extends Equatable {
  final ProductsPageEntity products;
  final int totalResults;
  final String searchTerm;
  final double searchTimeMs;
  final List<String> suggestedKeywords;
  final AppliedFiltersEntity appliedFilters;

  const SearchDataEntity({
    required this.products,
    required this.totalResults,
    required this.searchTerm,
    required this.searchTimeMs,
    required this.suggestedKeywords,
    required this.appliedFilters,
  });

  @override
  List<Object?> get props => [
        products,
        totalResults,
        searchTerm,
        searchTimeMs,
        suggestedKeywords,
        appliedFilters,
      ];
}

class ProductsPageEntity extends Equatable {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final List<SearchProductEntity> items;

  const ProductsPageEntity({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.items,
  });

  @override
  List<Object?> get props => [
        currentPage,
        pageSize,
        totalCount,
        totalPages,
        hasPrevious,
        hasNext,
        items,
      ];
}

class SearchProductEntity extends Equatable {
  final String id;
  final String productName;
  final String description;
  final double basePrice;
  final double discountPrice;
  final double finalPrice;
  final int stockQuantity;
  final String? primaryImageUrl;
  final int quantitySold;
  final double discountPercentage;
  final bool isOnSale;
  final bool inStock;
  final String shopId;
  final String shopName;
  final String shopLocation;
  final double shopRating;
  final String categoryId;
  final String categoryName;
  final double averageRating;
  final int reviewCount;
  final String? highlightedName;

  const SearchProductEntity({
    required this.id,
    required this.productName,
    required this.description,
    required this.basePrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.stockQuantity,
    this.primaryImageUrl,
    required this.quantitySold,
    required this.discountPercentage,
    required this.isOnSale,
    required this.inStock,
    required this.shopId,
    required this.shopName,
    required this.shopLocation,
    required this.shopRating,
    required this.categoryId,
    required this.categoryName,
    required this.averageRating,
    required this.reviewCount,
    this.highlightedName,
  });

  @override
  List<Object?> get props => [
        id,
        productName,
        description,
        basePrice,
        discountPrice,
        finalPrice,
        stockQuantity,
        primaryImageUrl,
        quantitySold,
        discountPercentage,
        isOnSale,
        inStock,
        shopId,
        shopName,
        shopLocation,
        shopRating,
        categoryId,
        categoryName,
        averageRating,
        reviewCount,
        highlightedName,
      ];
}

class AppliedFiltersEntity extends Equatable {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? shopId;
  final String sortBy;
  final bool inStockOnly;
  final int? minRating;
  final bool onSaleOnly;

  const AppliedFiltersEntity({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.shopId,
    required this.sortBy,
    required this.inStockOnly,
    this.minRating,
    required this.onSaleOnly,
  });

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
      ];
}
