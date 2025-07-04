import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  HomeBloc({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<SearchProductsEvent>(_onSearchProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
  }

  Future<void> _onLoadHomeData(LoadHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      // Load categories and products concurrently
      final results = await Future.wait([
        getCategoriesUseCase(),
        getProductsUseCase(page: 1, limit: 20),
      ]);

      final categoriesResult = results[0];
      final productsResult = results[1];

      if (categoriesResult.isLeft() || productsResult.isLeft()) {
        // Handle errors
        final categoryError = categoriesResult.fold((failure) => failure.message, (_) => null);
        final productError = productsResult.fold((failure) => failure.message, (_) => null);
        
        final errorMessage = categoryError ?? productError ?? 'Unknown error occurred';
        emit(HomeError(errorMessage));
        return;
      }      final categories = categoriesResult.fold((_) => <CategoryEntity>[], (categories) => categories as List<CategoryEntity>);
      final products = productsResult.fold((_) => <ProductEntity>[], (products) => products as List<ProductEntity>);

      emit(HomeLoaded(
        categories: categories,
        products: products,
        liveStreams: [], // TODO: Load livestreams when API is ready
        hasMoreProducts: products.length >= 20,
      ));
    } catch (e) {
      emit(HomeError('Unexpected error occurred: $e'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeDataEvent event, Emitter<HomeState> emit) async {
    // Use the same logic as LoadHomeDataEvent
    add(const LoadHomeDataEvent());
  }

  Future<void> _onSearchProducts(SearchProductsEvent event, Emitter<HomeState> emit) async {
    try {
      final result = await searchProductsUseCase(query: event.query, page: 1, limit: 20);
      
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (products) => emit(ProductSearchLoaded(
          searchResults: products,
          query: event.query,
        )),
      );
    } catch (e) {
      emit(HomeError('Search failed: $e'));
    }
  }

  Future<void> _onLoadMoreProducts(LoadMoreProductsEvent event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded && !currentState.isLoadingMore && currentState.hasMoreProducts) {
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final currentPage = (currentState.products.length / 20).ceil() + 1;
        final result = await getProductsUseCase(page: currentPage, limit: 20);
        
        result.fold(
          (failure) => emit(currentState.copyWith(isLoadingMore: false)),
          (newProducts) {
            final allProducts = [...currentState.products, ...newProducts];
            emit(currentState.copyWith(
              products: allProducts,
              isLoadingMore: false,
              hasMoreProducts: newProducts.length >= 20,
            ));
          },
        );
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
