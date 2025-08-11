import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_message_entity.dart';

abstract class LiveStreamMessageRepository {
  Future<Either<Failure, LiveStreamChatMessageEntity>> joinChatLiveStream(String livestreamId);
}
