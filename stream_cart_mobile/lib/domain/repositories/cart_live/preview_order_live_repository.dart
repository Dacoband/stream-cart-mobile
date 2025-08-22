import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/cart_live/preview_order_live_entity.dart';

abstract class PreviewOrderLiveRepository {
	Future<Either<Failure, PreviewOrderLiveEntity>> getPreviewOrderLive(List<String> cartItemIds);
}
