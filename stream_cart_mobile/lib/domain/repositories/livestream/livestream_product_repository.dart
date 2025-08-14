import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/domain/entities/livestream/livestream_product_entity.dart';

import '../../../core/error/failures.dart';

abstract class LiveStreamProductRepository {
  Future<Either<Failure, List<LiveStreamProductEntity>>> getProductsByLiveStream(String liveStreamId);
  Future<Either<Failure, List<LiveStreamProductEntity>>> getPinnedProductsByLiveStream(String liveStreamId, {int? limit});
}