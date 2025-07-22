import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_product_detail_usecase.dart';
import '../../../domain/usecases/get_product_images_usecase.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../cart/cart_bloc.dart';
import '../cart/cart_event.dart' as cart_events;
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetailUseCase getProductDetailUseCase;
  final GetProductImagesUseCase getProductImagesUseCase;
  final AddToCartUseCase addToCartUseCase;
  final CartBloc cartBloc;

  ProductDetailBloc({
    required this.getProductDetailUseCase,
    required this.getProductImagesUseCase,
    required this.addToCartUseCase,
    required this.cartBloc,
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
    
    emit(AddToCartLoading());
    
    // Kiểm tra xem sản phẩm có variant không
    bool hasVariant = false;
    String variantId = event.variantId ?? '';
    
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      hasVariant = currentState.productDetail.variants.isNotEmpty;
      
      if (hasVariant) {
        // Sản phẩm có variant - cần chọn variant
        if (variantId.isEmpty) {
          variantId = currentState.selectedVariantId ?? '';
        }
        
        if (variantId.isEmpty) {
          emit(const AddToCartError('Vui lòng chọn phiên bản sản phẩm'));
          return;
        }
      } else {
        // Sản phẩm không có variant - có thể để variantId rỗng hoặc null
        variantId = '';
      }
    }
    
    final params = AddToCartParams(
      productId: event.productId,
      variantId: variantId,
      quantity: event.quantity,
    );
    
    final result = await addToCartUseCase(params);
    
    result.fold(
      (failure) {
        print('[ProductDetailBloc] Error adding to cart: ${failure.message}');
        emit(AddToCartError(failure.message));
      },
      (response) {
        if (response.success) {
          print('[ProductDetailBloc] Successfully added to cart');
          emit(AddToCartSuccess(response.message));
          
          // Refresh the cart to update the badge count
          cartBloc.add(cart_events.LoadCartEvent());
        } else {
          final errorMessage = response.errors.isNotEmpty 
            ? response.errors.first 
            : 'Lỗi không xác định khi thêm vào giỏ hàng';
          print('[ProductDetailBloc] Error from API: $errorMessage');
          emit(AddToCartError(errorMessage));
        }
      },
    );
    
    // Return to previous state after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (state is ProductDetailLoaded) {
      // Keep the current loaded state
      return;
    } else {
      // If we're still in success/error state, reload the product detail
      add(LoadProductDetailEvent(event.productId));
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
