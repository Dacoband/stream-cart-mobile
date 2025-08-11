import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_product_entity.dart';
import '../../repositories/livestream/livestream_product_repository.dart';

class GetProductsByLiveStreamUseCase {
  final LiveStreamProductRepository repository;
  GetProductsByLiveStreamUseCase(this.repository);

  Future<Either<Failure, List<LiveStreamProductEntity>>> call(String liveStreamId) async {
    return await repository.getProductsByLiveStream(liveStreamId);
  }
}
