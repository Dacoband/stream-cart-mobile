import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_product_entity.dart';
import '../../repositories/livestream/livestream_product_repository.dart';

class GetPinnedProductsByLiveStreamUseCase {
  final LiveStreamProductRepository repository;
  GetPinnedProductsByLiveStreamUseCase(this.repository);

  Future<Either<Failure, List<LiveStreamProductEntity>>> call(String liveStreamId, {int? limit}) {
  return repository.getPinnedProductsByLiveStream(liveStreamId, limit: limit);
  }
}
