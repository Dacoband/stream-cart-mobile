import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_message_entity.dart';

abstract class LiveStreamMessageRepository {
  Future<Either<Failure, LiveStreamChatMessageEntity>> joinChatLiveStream(String livestreamId);
  Future<Either<Failure, LiveStreamChatMessageEntity>> sendMessageToLiveStream({ required String livestreamId, required String message, int messageType = 0, String? replyToMessageId});
  Future<Either<Failure, List<LiveStreamChatMessageEntity>>> getLiveStreamMessages(String livestreamId);
}
