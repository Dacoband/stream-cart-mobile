import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/chat/chat_entity.dart';
import '../../repositories/chat_repository.dart';

class LoadChatRoomsUseCase {
  final ChatRepository repository;

  LoadChatRoomsUseCase(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) {
    return repository.getChatRooms(pageNumber: pageNumber, pageSize: pageSize, isActive: isActive);
  }
}