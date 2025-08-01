import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/product/get_product_detail_usecase.dart';
import '../../../domain/usecases/product/get_product_images_usecase.dart';
import '../../../domain/usecases/cart/add_to_cart_usecase.dart';
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
    emit(ProductDetailLoading());

    final result = await getProductDetailUseCase(event.productId);
    
    result.fold(
      (failure) {
        emit(ProductDetailError(failure.message));
      },
      (productDetail) {
        emit(ProductDetailLoaded(
          productDetail: productDetail,
          selectedVariantId: productDetail.variants.isNotEmpty ? productDetail.variants.first.id : null,
        ));
        add(LoadProductImagesEvent(event.productId));
      },
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    print('[ProductDetailBloc] Adding to cart: ${event.productId}');
    
    if (state is! ProductDetailLoaded) {
      emit(const AddToCartError('Không thể thêm vào giỏ hàng. Vui lòng thử lại.'));
      return;
    }
    
    final currentState = state as ProductDetailLoaded;
    
    emit(currentState.copyWith(isAddingToCart: true, addToCartMessage: null));
    
    // Kiểm tra xem sản phẩm có variant không
    bool hasVariant = currentState.productDetail.variants.isNotEmpty;
    String variantId = event.variantId ?? '';
    
    if (hasVariant) {
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
        emit(currentState.copyWith(
          isAddingToCart: false,
          addToCartMessage: failure.message,
          addToCartSuccess: false,
        ));
      },
      (response) {
        if (response.success) {
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
        },
        (images) {
          print('[ProductDetailBloc] Successfully loaded ${images.length} product images');
          emit(currentState.copyWith(productImages: images));
        },
      );
    }
  }
}
