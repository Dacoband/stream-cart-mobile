import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/usecases/search/search_products_usecase.dart' as search;
import '../../../domain/usecases/category/get_categories_usecase.dart';
import '../../../domain/usecases/product/get_product_primary_images_usecase.dart';
import '../../../core/services/search_history_service.dart';
import '../../../core/error/failures.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final search.SearchProductsUseCase searchProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductPrimaryImagesUseCase getProductPrimaryImagesUseCase;
  final SearchHistoryService searchHistoryService;

  SearchBloc({
    required this.searchProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductPrimaryImagesUseCase,
    required this.searchHistoryService,
  }) : super(const SearchInitial()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SearchSubmittedEvent>(_onSearchSubmitted);
    on<ClearSearchEvent>(_onClearSearch);
    on<SearchHistoryLoadedEvent>(_onSearchHistoryLoaded);
    on<SearchHistoryItemSelectedEvent>(_onSearchHistoryItemSelected);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
  }

  void _onSearchQueryChanged(SearchQueryChangedEvent event, Emitter<SearchState> emit) {
    // Debounce search while typing - for now just clear if empty
    if (event.query.trim().isEmpty) {
      emit(SearchInitial(searchHistory: searchHistoryService.getSearchHistory()));
    }
  }

  Future<void> _onSearchSubmitted(SearchSubmittedEvent event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    print('[SearchBloc] Searching for: $query');
    emit(SearchLoading());

    try {
      // Save to search history
      await searchHistoryService.addSearchQuery(query);

      // Search both products and categories in parallel
      final List<dynamic> futures = await Future.wait([
        searchProductsUseCase(query: query, page: 1, limit: 20),
        getCategoriesUseCase(),
      ]);

      final productsResult = futures[0] as Either<Failure, List<ProductEntity>>;
      final categoriesResult = futures[1] as Either<Failure, List<CategoryEntity>>;

      final products = productsResult.fold(
        (failure) {
          print('[SearchBloc] Products search failed: ${failure.message}');
          return <ProductEntity>[];
        },
        (products) => products,
      );

      final allCategories = categoriesResult.fold(
        (failure) {
          print('[SearchBloc] Categories fetch failed: ${failure.message}');
          return <CategoryEntity>[];
        },
        (categories) => categories,
      );

      // Filter categories by search query
      final filteredCategories = allCategories.where((category) =>
        category.categoryName.toLowerCase().contains(query.toLowerCase()) ||
        category.description.toLowerCase().contains(query.toLowerCase())
      ).toList();

      if (products.isEmpty && filteredCategories.isEmpty) {
        emit(SearchEmpty(query));
        return;
      }

      emit(SearchLoaded(
        query: query,
        products: products,
        categories: filteredCategories,
        hasMoreProducts: products.length >= 20,
      ));

      // Load product images if we have products
      if (products.isNotEmpty) {
        final productIds = products.map((p) => p.id).toList();
        final imagesResult = await getProductPrimaryImagesUseCase(productIds);
        
        imagesResult.fold(
          (failure) {
            print('[SearchBloc] Failed to load product images: ${failure.message}');
          },
          (productImages) {
            if (state is SearchLoaded) {
              final currentState = state as SearchLoaded;
              emit(currentState.copyWith(productImages: productImages));
            }
          },
        );
      }
    } catch (e) {
      print('[SearchBloc] Search error: $e');
      emit(SearchError('Có lỗi xảy ra khi tìm kiếm: $e'));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial(searchHistory: searchHistoryService.getSearchHistory()));
  }

  void _onSearchHistoryLoaded(SearchHistoryLoadedEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial(searchHistory: searchHistoryService.getSearchHistory()));
  }

  void _onSearchHistoryItemSelected(SearchHistoryItemSelectedEvent event, Emitter<SearchState> emit) {
    add(SearchSubmittedEvent(event.query));
  }

  void _onClearSearchHistory(ClearSearchHistoryEvent event, Emitter<SearchState> emit) {
    searchHistoryService.clearSearchHistory();
    emit(SearchInitial(searchHistory: []));
  }
}
