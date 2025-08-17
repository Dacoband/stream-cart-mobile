import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_entity.dart';
import '../../repositories/livestream/livestream_repository.dart';

class GetLiveStreamsByShopUseCase {
  final LiveStreamRepository repository;
  GetLiveStreamsByShopUseCase(this.repository);

  Future<Either<Failure, List<LiveStreamEntity>>> call(String shopId) async {
    return await repository.getLiveStreamsByShop(shopId);
  }
}
