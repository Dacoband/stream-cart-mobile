import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/products/product_entity.dart';
import '../../../domain/usecases/category/get_categories_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/get_product_primary_images_usecase.dart';
import '../../../domain/usecases/flash-sale/get_flash_sales.dart';
import '../../../domain/usecases/flash-sale/get_flash_sale_products.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetProductPrimaryImagesUseCase getProductPrimaryImagesUseCase;
  final GetFlashSalesUseCase getFlashSalesUseCase;
  final GetFlashSaleProductsUseCase getFlashSaleProductsUseCase;

  HomeBloc({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.getProductPrimaryImagesUseCase,
    required this.getFlashSalesUseCase,
    required this.getFlashSaleProductsUseCase,
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
      print('🏠 HomeBloc: Starting to load home data...');
      
      // Load categories and products concurrently
      final categoriesResult = await getCategoriesUseCase();
      print('📦 Categories result received');
      
      final productsResult = await getProductsUseCase(page: 1, limit: 20);
      print('🛍️ Products result received');

      // Check for errors
      String? errorMessage;
      
      categoriesResult.fold(
        (failure) {
          print('❌ Categories error: ${failure.message}');
          errorMessage = 'Categories: ${failure.message}';
        },
        (categories) {
          print('✅ Categories loaded: ${categories.length} items');
        },
      );
      
      if (errorMessage == null) {
        productsResult.fold(
          (failure) {
            print('❌ Products error: ${failure.message}');
            errorMessage = 'Products: ${failure.message}';
          },
          (products) {
            print('✅ Products loaded: ${products.length} items');
          },
        );
      }

      if (errorMessage != null) {
        print('💥 Emitting error: $errorMessage');
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

      print('🎉 Emitting HomeLoaded with ${categories.length} categories and ${products.length} products');
      
      emit(HomeLoaded(
        categories: categories,
        products: products,
        liveStreams: [], // TODO: Load livestreams when API is ready
        hasMoreProducts: products.length >= 20,
        isLoadingFlashSales: true, // Set loading state for flash sales
      ));

      // Auto-load flash sales and product images after initial load
      if (products.isNotEmpty) {
        final productIds = products.map((p) => p.id).toList();
        print('🖼️ Auto-loading product images for ${productIds.length} products');
        add(LoadProductImagesEvent(productIds));
      }
      
      // Load flash sales automatically
      print('🔥 Auto-loading flash sales...');
      add(const LoadFlashSalesEvent());
    } catch (e) {
      print('💥 Unexpected error in HomeBloc: $e');
      emit(HomeError('Unexpected error occurred: $e'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeDataEvent event, Emitter<HomeState> emit) async {
    print('🔄 RefreshHomeData event triggered');
    
    // Also refresh flash sales when refreshing home data
    final currentState = state;
    if (currentState is HomeLoaded) {
      print('🔥 Refreshing flash sales during home data refresh...');
      add(const LoadFlashSalesEvent());
    }
    
    // Use the same logic as LoadHomeDataEvent
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
      final currentState = state as HomeLoaded;
      
      print('🖼️ HomeBloc: Loading images for ${event.productIds.length} products');
      print('🖼️ Current state before loading images - flashSales: ${currentState.flashSales.length}, isLoadingFlashSales: ${currentState.isLoadingFlashSales}');
      
      final result = await getProductPrimaryImagesUseCase(event.productIds);
      
      result.fold(
        (failure) {
          print('❌ HomeBloc: Error loading product images: ${failure.message}');
          // Don't change state on error, just log it
        },
        (primaryImages) {
          print('✅ HomeBloc: Successfully loaded ${primaryImages.length} product images');
          
          // Get the current state again to ensure we have the latest flash sales data
          final latestState = state as HomeLoaded;
          print('🖼️ Latest state when emitting images - flashSales: ${latestState.flashSales.length}, isLoadingFlashSales: ${latestState.isLoadingFlashSales}');
          
          emit(latestState.copyWith(productImages: primaryImages));
        },
      );
    }
  }

  Future<void> _onLoadFlashSales(LoadFlashSalesEvent event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(isLoadingFlashSales: true));

      try {
        print('🔥 HomeBloc: Loading flash sales...');
        
        final flashSalesResult = await getFlashSalesUseCase();
        
        await flashSalesResult.fold(
          (failure) async {
            print('❌ HomeBloc: Error loading flash sales: ${failure.message}');
            emit(currentState.copyWith(isLoadingFlashSales: false));
          },
          (flashSales) async {
            print('✅ HomeBloc: Successfully loaded ${flashSales.length} flash sales');
            
            // Extract product IDs from flash sales
            final productIds = flashSales
                .map((flashSale) => flashSale.productId)
                .toSet()
                .toList();

            if (productIds.isNotEmpty) {
              final productsResult = await getFlashSaleProductsUseCase(productIds);
              
              productsResult.fold(
                (failure) {
                  print('❌ HomeBloc: Error loading flash sale products: ${failure.message}');
                  emit(currentState.copyWith(
                    flashSales: flashSales,
                    isLoadingFlashSales: false,
                  ));
                },
                (flashSaleProducts) {
                  print('✅ HomeBloc: Successfully loaded ${flashSaleProducts.length} flash sale products');
                  print('🔥 About to emit flash sales state - flashSales: ${flashSales.length}, flashSaleProducts: ${flashSaleProducts.length}');
                  emit(currentState.copyWith(
                    flashSales: flashSales,
                    flashSaleProducts: flashSaleProducts,
                    isLoadingFlashSales: false,
                  ));
                  print('🔥 Flash sales state emitted successfully');
                },
              );
            } else {
              emit(currentState.copyWith(
                flashSales: flashSales,
                isLoadingFlashSales: false,
              ));
            }
          },
        );
      } catch (e) {
        print('💥 Unexpected error loading flash sales: $e');
        emit(currentState.copyWith(isLoadingFlashSales: false));
      }
    }
  }

  Future<void> _onRefreshFlashSales(RefreshFlashSalesEvent event, Emitter<HomeState> emit) async {
    add(const LoadFlashSalesEvent());
  }
}
