import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_category_detail_usecase.dart';
import '../../../domain/usecases/get_products_by_category_usecase.dart';
import '../../../domain/usecases/get_product_primary_images_usecase.dart';
import 'category_detail_event.dart';
import 'category_detail_state.dart';

class CategoryDetailBloc extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final GetCategoryDetailUseCase getCategoryDetailUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final GetProductPrimaryImagesUseCase getProductPrimaryImagesUseCase;

  CategoryDetailBloc({
    required this.getCategoryDetailUseCase,
    required this.getProductsByCategoryUseCase,
    required this.getProductPrimaryImagesUseCase,
  }) : super(CategoryDetailInitial()) {
    on<LoadCategoryDetailEvent>(_onLoadCategoryDetail);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadCategoryDetail(
    LoadCategoryDetailEvent event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(CategoryDetailLoading());

    try {
      final categoryResult = await getCategoryDetailUseCase(event.categoryId);
      
      await categoryResult.fold(
        (failure) async => emit(CategoryDetailError(failure.message)),
        (category) async {
          if (emit.isDone) return;
          final parentProductsResult = await getProductsByCategoryUseCase(event.categoryId);
          List<ProductEntity> allProducts = [];
          parentProductsResult.fold(
            (failure) {
              print('⚠️ Warning: Failed to load parent category products: ${failure.message}');
            },
            (parentProducts) {
              allProducts.addAll(parentProducts);
            },
          );
          
          for (var subcategory in category.subCategories) {
            if (emit.isDone) return;
            
            try {
              final subcategoryProductsResult = await getProductsByCategoryUseCase(subcategory.categoryId);
              subcategoryProductsResult.fold(
                (failure) {
                  print('⚠️ Warning: Failed to load products from subcategory ${subcategory.categoryName}: ${failure.message}');
                },
                (subcategoryProducts) {
                  allProducts.addAll(subcategoryProducts);
                },
              );
            } catch (e) {
              print('Error loading products from subcategory ${subcategory.categoryName}: $e');
            }
          }
          
          final uniqueProducts = allProducts.fold<Map<String, ProductEntity>>(
            {},
            (map, product) {
              map[product.id] = product;
              return map;
            },
          ).values.toList();

          Map<String, String> productImages = {};
          if (uniqueProducts.isNotEmpty && !emit.isDone) {
            try {
              final productIds = uniqueProducts.map((product) => product.id).toList();
              final imagesResult = await getProductPrimaryImagesUseCase(productIds);
              
              imagesResult.fold(
                (failure) {
                  print('Warning: Failed to load product images: ${failure.message}');
                },
                (images) {
                  productImages = images;
                },
              );
            } catch (e) {
              print('Error loading product images: $e');
            }
          }
          if (!emit.isDone) {
            emit(CategoryDetailLoaded(
              category: category,
              products: uniqueProducts,
              productImages: productImages,
            ));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(CategoryDetailError('Đã có lỗi xảy ra: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<CategoryDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is CategoryDetailLoaded) {
      final result = await getProductsByCategoryUseCase(event.categoryId);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(CategoryDetailError(failure.message));
          }
        },
        (products) {
          if (!emit.isDone) {
            emit(CategoryDetailLoaded(
              category: currentState.category,
              products: products,
              productImages: currentState.productImages,
            ));
          }
        },
      );
    }
  }
}
