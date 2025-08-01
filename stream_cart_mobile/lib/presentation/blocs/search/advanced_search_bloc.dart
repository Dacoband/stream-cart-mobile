import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/usecases/search/search_products_advanced_usecase.dart';
import '../../../domain/entities/search/search_filters.dart';
import 'advanced_search_event.dart';
import 'advanced_search_state.dart';

class AdvancedSearchBloc extends Bloc<AdvancedSearchEvent, AdvancedSearchState> {
  final SearchProductsAdvancedUseCase searchProductsAdvancedUseCase;
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  AdvancedSearchBloc({
    required this.searchProductsAdvancedUseCase,
  }) : super(const SearchInitial()) {
    on<SearchProductsEvent>(_onSearchProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ClearFiltersEvent>(_onClearFilters);
    on<ClearSearchEvent>(_onClearSearch);
    on<SaveSearchHistoryEvent>(_onSaveSearchHistory);
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<AdvancedSearchState> emit) async {
    if (event.searchTerm.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final filters = event.filters ?? const SearchFilters();
      
      final result = await searchProductsAdvancedUseCase(
        searchTerm: event.searchTerm,
        pageNumber: filters.pageNumber,
        pageSize: filters.pageSize,
        categoryId: filters.categoryId,
        minPrice: filters.minPrice,
        maxPrice: filters.maxPrice,
        shopId: filters.shopId,
        sortBy: filters.sortBy,
        inStockOnly: filters.inStockOnly,
        minRating: filters.minRating,
        onSaleOnly: filters.onSaleOnly,
      );

      result.fold(
        (failure) {
          print('[AdvancedSearchBloc] Search failed: ${failure.message}');
          emit(SearchError(
            message: failure.message,
            searchTerm: event.searchTerm,
            filters: filters,
          ));
        },
        (searchResponse) {
          print('[AdvancedSearchBloc] Search successful! Total results: ${searchResponse.data.totalResults}');
          print('[AdvancedSearchBloc] Products count: ${searchResponse.data.products.items.length}');
          
          if (searchResponse.data.totalResults == 0) {
            print('[AdvancedSearchBloc] Emitting SearchEmpty state');
            emit(SearchEmpty(
              searchTerm: event.searchTerm,
              filters: filters,
              suggestedKeywords: searchResponse.data.suggestedKeywords,
            ));
          } else {
            print('[AdvancedSearchBloc] Emitting SearchSuccess state');
            emit(SearchSuccess(
              searchResponse: searchResponse,
              filters: filters,
              allProducts: searchResponse.data.products.items,
            ));
            
            // Save to search history
            add(SaveSearchHistoryEvent(event.searchTerm));
          }
        },
      );
    } catch (e) {
      print('[AdvancedSearchBloc] Search error: $e');
      emit(SearchError(
        message: 'Có lỗi xảy ra khi tìm kiếm: $e',
        searchTerm: event.searchTerm,
        filters: event.filters ?? const SearchFilters(),
      ));
    }
  }

  void _onLoadMoreProducts(LoadMoreProductsEvent event, Emitter<AdvancedSearchState> emit) async {
    if (state is! SearchSuccess) return;

    final currentState = state as SearchSuccess;
    if (!currentState.searchResponse.data.products.hasNext) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPageFilters = event.filters.copyWith(
        pageNumber: currentState.searchResponse.data.products.currentPage + 1,
      );

      final result = await searchProductsAdvancedUseCase(
        searchTerm: event.searchTerm,
        pageNumber: nextPageFilters.pageNumber,
        pageSize: nextPageFilters.pageSize,
        categoryId: nextPageFilters.categoryId,
        minPrice: nextPageFilters.minPrice,
        maxPrice: nextPageFilters.maxPrice,
        shopId: nextPageFilters.shopId,
        sortBy: nextPageFilters.sortBy,
        inStockOnly: nextPageFilters.inStockOnly,
        minRating: nextPageFilters.minRating,
        onSaleOnly: nextPageFilters.onSaleOnly,
      );

      result.fold(
        (failure) {
          print('[AdvancedSearchBloc] Load more failed: ${failure.message}');
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (searchResponse) {
          final allProducts = [
            ...currentState.allProducts,
            ...searchResponse.data.products.items,
          ];

          emit(SearchSuccess(
            searchResponse: searchResponse,
            filters: nextPageFilters,
            allProducts: allProducts,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e) {
      print('[AdvancedSearchBloc] Load more error: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  void _onApplyFilters(ApplyFiltersEvent event, Emitter<AdvancedSearchState> emit) async {
    // Reset to first page when applying filters
    final filtersWithFirstPage = event.filters.copyWith(pageNumber: 1);
    
    add(SearchProductsEvent(
      searchTerm: event.searchTerm,
      filters: filtersWithFirstPage,
    ));
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<AdvancedSearchState> emit) async {
    add(SearchProductsEvent(
      searchTerm: event.searchTerm,
      filters: const SearchFilters(),
    ));
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<AdvancedSearchState> emit) async {
    final history = await _loadSearchHistory();
    emit(SearchInitial(searchHistory: history));
  }

  void _onSaveSearchHistory(SaveSearchHistoryEvent event, Emitter<AdvancedSearchState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList(_searchHistoryKey) ?? [];
      
      // Remove if already exists to avoid duplicates
      history.remove(event.searchTerm);
      
      // Add to beginning
      history.insert(0, event.searchTerm);
      
      // Keep only max items
      if (history.length > _maxHistoryItems) {
        history = history.take(_maxHistoryItems).toList();
      }
      
      await prefs.setStringList(_searchHistoryKey, history);
    } catch (e) {
      print('[AdvancedSearchBloc] Failed to save search history: $e');
    }
  }

  void _onLoadSearchHistory(LoadSearchHistoryEvent event, Emitter<AdvancedSearchState> emit) async {
    try {
      final history = await _loadSearchHistory();
      emit(SearchHistoryLoaded(history));
    } catch (e) {
      print('[AdvancedSearchBloc] Failed to load search history: $e');
      emit(const SearchHistoryLoaded([]));
    }
  }

  void _onClearSearchHistory(ClearSearchHistoryEvent event, Emitter<AdvancedSearchState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchHistoryKey);
      emit(const SearchHistoryLoaded([]));
    } catch (e) {
      print('[AdvancedSearchBloc] Failed to clear search history: $e');
    }
  }

  Future<List<String>> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_searchHistoryKey) ?? [];
    } catch (e) {
      print('[AdvancedSearchBloc] Failed to load search history: $e');
      return [];
    }
  }
}
