import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/products/product_variants_entity.dart';
import '../../../domain/usecases/product_variants/get_product_variants_by_product_id.dart';
import '../../../domain/usecases/product_variants/get_product_variant_by_id.dart';
import '../../../domain/usecases/product_variants/check_variant_availability.dart';
import '../../../domain/usecases/product_variants/get_cheapest_variant.dart';
import '../../../domain/usecases/product_variants/get_available_variants.dart';
import 'product_variants_event.dart';
import 'product_variants_state.dart';

class ProductVariantsBloc extends Bloc<ProductVariantsEvent, ProductVariantsState> {
  final GetProductVariantsByProductId getProductVariantsByProductId;
  final GetProductVariantById getProductVariantById;
  final CheckVariantAvailability checkVariantAvailability;
  final GetCheapestVariant getCheapestVariant;
  final GetAvailableVariants getAvailableVariants;

  ProductVariantsBloc({
    required this.getProductVariantsByProductId,
    required this.getProductVariantById,
    required this.checkVariantAvailability,
    required this.getCheapestVariant,
    required this.getAvailableVariants,
  }) : super(ProductVariantsInitial()) {
    on<GetProductVariantsByProductIdEvent>(_onGetProductVariantsByProductId);
    on<GetProductVariantByIdEvent>(_onGetProductVariantById);
    on<CheckVariantAvailabilityEvent>(_onCheckVariantAvailability);
    on<SelectVariantEvent>(_onSelectVariant);
    on<ClearSelectedVariantEvent>(_onClearSelectedVariant);
  }

  Future<void> _onGetProductVariantsByProductId(
    GetProductVariantsByProductIdEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    print('[ProductVariantsBloc] Loading variants for product: ${event.productId}');
    emit(ProductVariantsLoading());
    
    try {
      final result = await getProductVariantsByProductId(event.productId);
      
      print('[ProductVariantsBloc] Variants result type: ${result.runtimeType}');
      
      await result.fold(
        (failure) async {
          print('[ProductVariantsBloc] Error: ${failure.message}');
          if (!emit.isDone) { 
            emit(ProductVariantsError(failure.message));
          }
        },
        (variants) async {
          print('[ProductVariantsBloc] Loaded ${variants.length} variants');
          
          if (!emit.isDone) { 
            if (variants.isEmpty) {
              emit(const ProductVariantsLoaded(variants: []));
            } else {
              // Find cheapest variant
              try {
                final cheapestResult = await getCheapestVariant(event.productId);
                ProductVariantEntity? cheapestVariant;

                cheapestResult.fold(
                  (failure) => print('[ProductVariantsBloc] Could not get cheapest variant: ${failure.message}'),
                  (cheapest) => cheapestVariant = cheapest,
                );
                
                emit(ProductVariantsLoaded(
                  variants: variants,
                  selectedVariant: variants.isNotEmpty ? variants.first : null,
                  cheapestVariant: cheapestVariant,
                ));
              } catch (e) {
                print('[ProductVariantsBloc] Error getting cheapest variant: $e');
                emit(ProductVariantsLoaded(
                  variants: variants,
                  selectedVariant: variants.isNotEmpty ? variants.first : null,
                ));
              }
            }
          }
        },
      );
    } catch (e, stackTrace) {
      print('[ProductVariantsBloc] Exception: $e');
      print('[ProductVariantsBloc] StackTrace: $stackTrace');
      if (!emit.isDone) {
        emit(ProductVariantsError('Unexpected error: $e'));
      }
    }
  }

  Future<void> _onGetProductVariantById(
    GetProductVariantByIdEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    emit(ProductVariantsLoading());

    try {
      final result = await getProductVariantById(event.variantId);

      await result.fold(
        (failure) async {
          if (!emit.isDone) {
            emit(ProductVariantsError(failure.message));
          }
        },
        (variant) async {
          if (!emit.isDone) {
            emit(ProductVariantSelected(variant));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(ProductVariantsError('Unexpected error: $e'));
      }
    }
  }

  Future<void> _onSelectVariant(
    SelectVariantEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    if (state is ProductVariantsLoaded) {
      final currentState = state as ProductVariantsLoaded;
      final selectedVariant = currentState.variants.firstWhere(
        (variant) => variant.id == event.variantId,
        orElse: () => throw Exception('Variant not found'),
      );

      if (!emit.isDone) {
        emit(currentState.copyWith(selectedVariant: selectedVariant));
      }
    }
  }

  Future<void> _onClearSelectedVariant(
    ClearSelectedVariantEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    if (state is ProductVariantsLoaded) {
      final currentState = state as ProductVariantsLoaded;
      if (!emit.isDone) {
        emit(currentState.copyWith(clearSelectedVariant: true));
      }
    }
  }

  Future<void> _onCheckVariantAvailability(
    CheckVariantAvailabilityEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    try {
      final result = await checkVariantAvailability(
        CheckVariantAvailabilityParams(
          variantId: event.variantId,
          requestedQuantity: event.requestedQuantity,
        ),
      );
      
      await result.fold(
        (failure) async {
          if (!emit.isDone) {
            emit(ProductVariantsError(failure.message));
          }
        },
        (isAvailable) async {
          if (!emit.isDone) {
            emit(VariantAvailabilityChecked(
              isAvailable: isAvailable,
              variantId: event.variantId,
              requestedQuantity: event.requestedQuantity,
            ));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(ProductVariantsError('Failed to check availability: $e'));
      }
    }
  }
}