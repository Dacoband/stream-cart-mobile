import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class MarkChatRoomAsReadUseCase {
  final ChatRepository repository;

  MarkChatRoomAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String chatRoomId) {
    return repository.markChatRoomAsRead(chatRoomId);
  }
}