import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/livestream/livestream_message_entity.dart';
import '../../repositories/livestream/livestream_message_repository.dart';

class JoinChatLiveStreamUseCase {
  final LiveStreamMessageRepository repository;
  JoinChatLiveStreamUseCase(this.repository);

  Future<Either<Failure, LiveStreamChatMessageEntity>> call(String liveStreamId) async {
    return await repository.joinChatLiveStream(liveStreamId);
  }
}
