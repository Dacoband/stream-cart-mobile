import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/cart_live/preview_order_live_entity.dart';
import '../../repositories/cart_live/preview_order_live_repository.dart';

class GetPreviewOrderLiveUsecase {
  final PreviewOrderLiveRepository repository;
  GetPreviewOrderLiveUsecase(this.repository);

  Future<Either<Failure, PreviewOrderLiveEntity>> call(List<String> cartItemIds) async {
    return await repository.getPreviewOrderLive(cartItemIds);
  }
}
