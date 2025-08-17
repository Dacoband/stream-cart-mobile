// lib/domain/repositories/deliveries/deliveries_repository.dart
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/deliveries/preview_deliveries_entity.dart';
import '../../entities/deliveries/preview_deliveries_response_entity.dart';

abstract class DeliveriesRepository {
  Future<Either<Failure, PreviewDeliveriesResponseEntity>> previewOrder(
    PreviewDeliveriesEntity request,
  );
}