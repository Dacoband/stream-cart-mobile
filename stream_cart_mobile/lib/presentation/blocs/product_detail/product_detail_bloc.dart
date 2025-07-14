import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_product_detail_usecase.dart';
import '../../../domain/usecases/get_product_images_usecase.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetailUseCase getProductDetailUseCase;
  final GetProductImagesUseCase getProductImagesUseCase;

  ProductDetailBloc({
    required this.getProductDetailUseCase,
    required this.getProductImagesUseCase,
  }) : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
    on<AddToCartEvent>(_onAddToCart);
    on<SelectVariantEvent>(_onSelectVariant);
    on<LoadProductImagesEvent>(_onLoadProductImages);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    print('[ProductDetailBloc] Loading product detail for ID: ${event.productId}');
    emit(ProductDetailLoading());

    final result = await getProductDetailUseCase(event.productId);
    
    result.fold(
      (failure) {
        print('[ProductDetailBloc] Error loading product detail: ${failure.message}');
        emit(ProductDetailError(failure.message));
      },
      (productDetail) {
        print('[ProductDetailBloc] Successfully loaded product detail: ${productDetail.productName}');
        emit(ProductDetailLoaded(
          productDetail: productDetail,
          selectedVariantId: productDetail.variants.isNotEmpty ? productDetail.variants.first.variantId : null,
        ));
        
        // Automatically load product images after product detail is loaded
        add(LoadProductImagesEvent(event.productId));
      },
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    print('[ProductDetailBloc] Adding to cart: ${event.productId}');
    
    // TODO: Implement add to cart functionality when cart API is ready
    emit(AddToCartSuccess('Sản phẩm đã được thêm vào giỏ hàng'));
    
    // Return to previous state after showing success message
    await Future.delayed(const Duration(seconds: 2));
    if (state is ProductDetailLoaded) {
      // Keep the current loaded state
      return;
    }
  }

  void _onSelectVariant(
    SelectVariantEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    print('[ProductDetailBloc] Selecting variant: ${event.variantId}');
    
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(currentState.copyWith(selectedVariantId: event.variantId));
    }
  }

  Future<void> _onLoadProductImages(
    LoadProductImagesEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    print('[ProductDetailBloc] Loading product images for: ${event.productId}');
    
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      
      final result = await getProductImagesUseCase(event.productId);
      
      result.fold(
        (failure) {
          print('[ProductDetailBloc] Error loading product images: ${failure.message}');
          // Keep current state, just log the error
        },
        (images) {
          print('[ProductDetailBloc] Successfully loaded ${images.length} product images');
          emit(currentState.copyWith(productImages: images));
        },
      );
    }
  }
}
