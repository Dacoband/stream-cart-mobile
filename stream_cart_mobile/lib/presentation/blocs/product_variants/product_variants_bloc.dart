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
    emit(ProductVariantsLoading());

    final result = await getProductVariantsByProductId(event.productId);

    result.fold(
      (failure) => emit(ProductVariantsError(failure.message)),
      (variants) async {
        final cheapestResult = await getCheapestVariant(event.productId);
        ProductVariantEntity? cheapestVariant;
        
        cheapestResult.fold(
          (failure) => cheapestVariant = null,
          (variant) => cheapestVariant = variant,
        );

        emit(ProductVariantsLoaded(
          variants: variants,
          cheapestVariant: cheapestVariant,
        ));
      },
    );
  }

  Future<void> _onGetProductVariantById(
    GetProductVariantByIdEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    emit(ProductVariantsLoading());

    final result = await getProductVariantById(event.variantId);

    result.fold(
      (failure) => emit(ProductVariantsError(failure.message)),
      (variant) => emit(ProductVariantSelected(variant)),
    );
  }

  Future<void> _onCheckVariantAvailability(
    CheckVariantAvailabilityEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    final params = CheckVariantAvailabilityParams(
      variantId: event.variantId,
      requestedQuantity: event.requestedQuantity,
    );

    final result = await checkVariantAvailability(params);

    result.fold(
      (failure) => emit(ProductVariantsError(failure.message)),
      (isAvailable) => emit(VariantAvailabilityChecked(
        isAvailable: isAvailable,
        variantId: event.variantId,
        requestedQuantity: event.requestedQuantity,
      )),
    );
  }

  Future<void> _onSelectVariant(
    SelectVariantEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    if (state is ProductVariantsLoaded) {
      final currentState = state as ProductVariantsLoaded;
      final selectedVariant = currentState.variants.firstWhere(
        (variant) => variant.id == event.variantId,
        orElse: () => currentState.variants.first,
      );

      emit(currentState.copyWith(selectedVariant: selectedVariant));
    }
  }

  Future<void> _onClearSelectedVariant(
    ClearSelectedVariantEvent event,
    Emitter<ProductVariantsState> emit,
  ) async {
    if (state is ProductVariantsLoaded) {
      final currentState = state as ProductVariantsLoaded;
      emit(currentState.copyWith(clearSelectedVariant: true));
    }
  }
}