import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_message_entity.dart';
import '../../repositories/livestream/livestream_message_repository.dart';

class GetLiveStreamMessagesUseCase {
  final LiveStreamMessageRepository repository;
  GetLiveStreamMessagesUseCase(this.repository);

  Future<Either<Failure, List<LiveStreamChatMessageEntity>>> call(String livestreamId) {
    return repository.getLiveStreamMessages(livestreamId);
  }
}
