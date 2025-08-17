import 'package:equatable/equatable.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/entities/category/category_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  final List<String> searchHistory;

  const SearchInitial({this.searchHistory = const []});

  @override
  List<Object?> get props => [searchHistory];
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final String query;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final Map<String, String> productImages;
  final bool hasMoreProducts;

  const SearchLoaded({
    required this.query,
    required this.products,
    required this.categories,
    this.productImages = const {},
    this.hasMoreProducts = false,
  });

  @override
  List<Object?> get props => [
    query,
    products,
    categories,
    productImages,
    hasMoreProducts,
  ];

  SearchLoaded copyWith({
    String? query,
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    Map<String, String>? productImages,
    bool? hasMoreProducts,
  }) {
    return SearchLoaded(
      query: query ?? this.query,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      productImages: productImages ?? this.productImages,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}
