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
    
    // Only proceed if we have a loaded state
    if (state is! ProductDetailLoaded) {
      emit(const AddToCartError('Không thể thêm vào giỏ hàng. Vui lòng thử lại.'));
      return;
    }
    
    final currentState = state as ProductDetailLoaded;
    
    // Emit loading state while keeping product detail
    emit(currentState.copyWith(isAddingToCart: true, addToCartMessage: null));
    
    // Kiểm tra xem sản phẩm có variant không
    bool hasVariant = currentState.productDetail.variants.isNotEmpty;
    String variantId = event.variantId ?? '';
    
    if (hasVariant) {
      // Sản phẩm có variant - cần chọn variant
      if (variantId.isEmpty) {
        variantId = currentState.selectedVariantId ?? '';
      }
      
      if (variantId.isEmpty) {
        emit(currentState.copyWith(
          isAddingToCart: false,
          addToCartMessage: 'Vui lòng chọn phiên bản sản phẩm',
          addToCartSuccess: false,
        ));
        return;
      }
    } else {
      // Sản phẩm không có variant - có thể để variantId rỗng hoặc null
      variantId = '';
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
        emit(currentState.copyWith(
          isAddingToCart: false,
          addToCartMessage: failure.message,
          addToCartSuccess: false,
        ));
      },
      (response) {
        if (response.success) {
          print('[ProductDetailBloc] Successfully added to cart');
          
          // Refresh the cart to update the badge count
          cartBloc.add(cart_events.LoadCartEvent());
          
          emit(currentState.copyWith(
            isAddingToCart: false,
            addToCartMessage: response.message,
            addToCartSuccess: true,
          ));
          
          // Clear the message after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (!isClosed && state is ProductDetailLoaded) {
              final latestState = state as ProductDetailLoaded;
              emit(latestState.copyWith(addToCartMessage: null));
            }
          });
        } else {
          final errorMessage = response.errors.isNotEmpty 
            ? response.errors.first 
            : 'Lỗi không xác định khi thêm vào giỏ hàng';
          print('[ProductDetailBloc] Error from API: $errorMessage');
          emit(currentState.copyWith(
            isAddingToCart: false,
            addToCartMessage: errorMessage,
            addToCartSuccess: false,
          ));
        }
      },
    );
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
