
import 'package:dartz/dartz.dart';
import '../../entities/deliveries/preview_deliveries_entity.dart';
import '../../entities/deliveries/preview_deliveries_response_entity.dart';
import '../../repositories/deliveries/deliveries_repository.dart';
import '../../../core/error/failures.dart';

class PreviewOrderDeliveryUseCase {
  final DeliveriesRepository repository;

  PreviewOrderDeliveryUseCase({required this.repository});

  Future<Either<Failure, PreviewDeliveriesResponseEntity>> call(
    PreviewDeliveriesEntity request,
  ) async {
    return await repository.previewOrder(request);
  }
}