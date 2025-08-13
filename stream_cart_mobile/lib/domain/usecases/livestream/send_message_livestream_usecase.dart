import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_message_entity.dart';
import '../../repositories/livestream/livestream_message_repository.dart';

class SendMessageLiveStreamUseCase {
  final LiveStreamMessageRepository repository;
  SendMessageLiveStreamUseCase(this.repository);

  Future<Either<Failure, LiveStreamChatMessageEntity>> call({
    required String livestreamId,
    required String message,
    int messageType = 0,
    String? replyToMessageId,
  }) {
    return repository.sendMessageToLiveStream(
      livestreamId: livestreamId,
      message: message,
      messageType: messageType,
      replyToMessageId: replyToMessageId,
    );
  }
}
