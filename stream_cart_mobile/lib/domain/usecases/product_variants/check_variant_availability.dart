import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/product/product_variants_repository.dart';

class CheckVariantAvailabilityParams {
  final String variantId;
  final int requestedQuantity;

  CheckVariantAvailabilityParams({
    required this.variantId,
    required this.requestedQuantity,
  });
}

class CheckVariantAvailability {
  final ProductVariantsRepository repository;

  CheckVariantAvailability(this.repository);

  Future<Either<Failure, bool>> call(CheckVariantAvailabilityParams params) async {
    final result = await repository.getProductVariantById(params.variantId);
    
    return result.fold(
      (failure) => Left(failure),
      (variant) {
        final isAvailable = variant.stock >= params.requestedQuantity;
        return Right(isAvailable);
      },
    );
  }
}