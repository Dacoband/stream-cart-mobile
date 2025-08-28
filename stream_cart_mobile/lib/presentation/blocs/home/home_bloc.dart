import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/usecases/category/get_categories_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/get_product_primary_images_usecase.dart';
import '../../../domain/usecases/flash-sale/get_flash_sales.dart';
import '../../../domain/usecases/flash-sale/get_flash_sale_products.dart';
import '../../../domain/usecases/livestream/get_active_livestreams_usecase.dart';
import '../../../domain/entities/livestream/livestream_entity.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetProductPrimaryImagesUseCase getProductPrimaryImagesUseCase;
  final GetFlashSalesUseCase getFlashSalesUseCase;
  final GetFlashSaleProductsUseCase getFlashSaleProductsUseCase; 
  final GetActiveLiveStreamsUseCase getActiveLiveStreamsUseCase;

  HomeBloc({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.getProductPrimaryImagesUseCase,
    required this.getFlashSalesUseCase,
  required this.getFlashSaleProductsUseCase,
  required this.getActiveLiveStreamsUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<LoadProductImagesEvent>(_onLoadProductImages);
    on<LoadFlashSalesEvent>(_onLoadFlashSales);
    on<RefreshFlashSalesEvent>(_onRefreshFlashSales);
  }

  Future<void> _onLoadHomeData(LoadHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      // Load categories and products concurrently
      final categoriesResult = await getCategoriesUseCase();
      final productsResult = await getProductsUseCase(page: 1, limit: 20);

      // Check for errors
      String? errorMessage;
      
      categoriesResult.fold(
        (failure) {
          errorMessage = 'Categories: ${failure.message}';
        },
        (categories) {
          // Categories loaded successfully
        },
      );
      
      if (errorMessage == null) {
        productsResult.fold(
          (failure) {
            errorMessage = 'Products: ${failure.message}';
          },
          (products) {
            // Products loaded successfully
          },
        );
      }

      if (errorMessage != null) {
        emit(HomeError(errorMessage!));
        return;
      }

      // Extract data if successful
      final categories = categoriesResult.fold(
        (_) => <CategoryEntity>[],
        (categories) => categories,
      );
      
      final products = productsResult.fold(
        (_) => <ProductEntity>[],
        (products) => products,
      );

      // Fetch livestreams in parallel now that API is ready
      final liveStreamsResult = await getActiveLiveStreamsUseCase();
      final liveStreams = liveStreamsResult.fold((_) => <LiveStreamEntity>[], (list) => list);

      emit(HomeLoaded(
        categories: categories,
        products: products,
        liveStreams: liveStreams,
        hasMoreProducts: products.length >= 20,
        isLoadingFlashSales: true,
      ));

      // Auto-load flash sales and product images after initial load
      if (products.isNotEmpty) {
        final productIds = products.map((p) => p.id).toList();
        add(LoadProductImagesEvent(productIds));
      }
      
      // Load flash sales automatically
      add(const LoadFlashSalesEvent());
    } catch (e) {
      emit(HomeError('Unexpected error occurred: $e'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeDataEvent event, Emitter<HomeState> emit) async {
  // Refresh everything including livestreams & flash sales
  add(const LoadHomeDataEvent());
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

  Future<void> _onLoadProductImages(LoadProductImagesEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final result = await getProductPrimaryImagesUseCase(event.productIds);
      
      result.fold(
        (failure) {
          // Don't change state on error, just log it silently
        },
        (primaryImages) {
          emit((state as HomeLoaded).copyWith(productImages: primaryImages));
        },
      );
    }
  }

  Future<void> _onLoadFlashSales(LoadFlashSalesEvent event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(isLoadingFlashSales: true));

      try {
        final flashSalesResult = await getFlashSalesUseCase();
        
        await flashSalesResult.fold(
          (failure) async {
            emit(currentState.copyWith(isLoadingFlashSales: false));
          },
          (flashSales) async {
            final hasEmbeddedProductInfo = flashSales.any((fs) =>
              (fs.productName != null && fs.productName!.isNotEmpty) ||
              (fs.productImageUrl != null && fs.productImageUrl!.isNotEmpty)
            );

            if (hasEmbeddedProductInfo) {
              emit(currentState.copyWith(
                flashSales: flashSales,
                isLoadingFlashSales: false,
              ));
            } else {
              final productIds = flashSales
                  .map((flashSale) => flashSale.productId)
                  .toSet()
                  .toList();

              if (productIds.isNotEmpty) {
                final productsResult = await getFlashSaleProductsUseCase(productIds);
                productsResult.fold(
                  (failure) {
                    emit(currentState.copyWith(
                      flashSales: flashSales,
                      isLoadingFlashSales: false,
                    ));
                  },
                  (flashSaleProducts) {
                    emit(currentState.copyWith(
                      flashSales: flashSales,
                      flashSaleProducts: flashSaleProducts,
                      isLoadingFlashSales: false,
                    ));
                  },
                );
              } else {
                emit(currentState.copyWith(
                  flashSales: flashSales,
                  isLoadingFlashSales: false,
                ));
              }
            }
          },
        );
      } catch (e) {
        emit(currentState.copyWith(isLoadingFlashSales: false));
      }
    }
  }

  Future<void> _onRefreshFlashSales(RefreshFlashSalesEvent event, Emitter<HomeState> emit) async {
    add(const LoadFlashSalesEvent());
  }
}
