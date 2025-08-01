import '../../../domain/entities/search/search_response_entity.dart';

class SearchResponseModel {
  final bool success;
  final String message;
  final SearchDataModel data;
  final List<String> errors;

  const SearchResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SearchDataModel.fromJson(json['data'] ?? {}),
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
    );
  }

  SearchResponseEntity toEntity() {
    return SearchResponseEntity(
      success: success,
      message: message,
      data: data.toEntity(),
      errors: errors,
    );
  }
}

class SearchDataModel {
  final ProductsPageModel products;
  final int totalResults;
  final String searchTerm;
  final double searchTimeMs;
  final List<String> suggestedKeywords;
  final AppliedFiltersModel appliedFilters;

  const SearchDataModel({
    required this.products,
    required this.totalResults,
    required this.searchTerm,
    required this.searchTimeMs,
    required this.suggestedKeywords,
    required this.appliedFilters,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      products: ProductsPageModel.fromJson(json['products'] ?? {}),
      totalResults: json['totalResults'] ?? 0,
      searchTerm: json['searchTerm'] ?? '',
      searchTimeMs: (json['searchTimeMs'] ?? 0.0).toDouble(),
      suggestedKeywords: json['suggestedKeywords'] != null
          ? List<String>.from(json['suggestedKeywords'])
          : [],
      appliedFilters: AppliedFiltersModel.fromJson(json['appliedFilters'] ?? {}),
    );
  }

  SearchDataEntity toEntity() {
    return SearchDataEntity(
      products: products.toEntity(),
      totalResults: totalResults,
      searchTerm: searchTerm,
      searchTimeMs: searchTimeMs,
      suggestedKeywords: suggestedKeywords,
      appliedFilters: appliedFilters.toEntity(),
    );
  }
}

class ProductsPageModel {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final List<SearchProductModel> items;

  const ProductsPageModel({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.items,
  });

  factory ProductsPageModel.fromJson(Map<String, dynamic> json) {
    return ProductsPageModel(
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasPrevious: json['hasPrevious'] ?? false,
      hasNext: json['hasNext'] ?? false,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => SearchProductModel.fromJson(item))
              .toList()
          : [],
    );
  }

  ProductsPageEntity toEntity() {
    return ProductsPageEntity(
      currentPage: currentPage,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      hasPrevious: hasPrevious,
      hasNext: hasNext,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}

class SearchProductModel {
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

  const SearchProductModel({
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

  factory SearchProductModel.fromJson(Map<String, dynamic> json) {
    return SearchProductModel(
      id: json['id'] ?? '',
      productName: json['productName'] ?? '',
      description: json['description'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      primaryImageUrl: json['primaryImageUrl'],
      quantitySold: json['quantitySold'] ?? 0,
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      isOnSale: json['isOnSale'] ?? false,
      inStock: json['inStock'] ?? true,
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      shopLocation: json['shopLocation'] ?? '',
      shopRating: (json['shopRating'] ?? 0).toDouble(),
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      highlightedName: json['highlightedName'],
    );
  }

  SearchProductEntity toEntity() {
    return SearchProductEntity(
      id: id,
      productName: productName,
      description: description,
      basePrice: basePrice,
      discountPrice: discountPrice,
      finalPrice: finalPrice,
      stockQuantity: stockQuantity,
      primaryImageUrl: primaryImageUrl,
      quantitySold: quantitySold,
      discountPercentage: discountPercentage,
      isOnSale: isOnSale,
      inStock: inStock,
      shopId: shopId,
      shopName: shopName,
      shopLocation: shopLocation,
      shopRating: shopRating,
      categoryId: categoryId,
      categoryName: categoryName,
      averageRating: averageRating,
      reviewCount: reviewCount,
      highlightedName: highlightedName,
    );
  }
}

class AppliedFiltersModel {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? shopId;
  final String sortBy;
  final bool inStockOnly;
  final int? minRating;
  final bool onSaleOnly;

  const AppliedFiltersModel({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.shopId,
    required this.sortBy,
    required this.inStockOnly,
    this.minRating,
    required this.onSaleOnly,
  });

  factory AppliedFiltersModel.fromJson(Map<String, dynamic> json) {
    return AppliedFiltersModel(
      categoryId: json['categoryId'],
      minPrice: json['minPrice'] != null ? (json['minPrice'] as num).toDouble() : null,
      maxPrice: json['maxPrice'] != null ? (json['maxPrice'] as num).toDouble() : null,
      shopId: json['shopId'],
      sortBy: json['sortBy'] ?? 'relevance',
      inStockOnly: json['inStockOnly'] ?? false,
      minRating: json['minRating'],
      onSaleOnly: json['onSaleOnly'] ?? false,
    );
  }

  AppliedFiltersEntity toEntity() {
    return AppliedFiltersEntity(
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      shopId: shopId,
      sortBy: sortBy,
      inStockOnly: inStockOnly,
      minRating: minRating,
      onSaleOnly: onSaleOnly,
    );
  }
}
