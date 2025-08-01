import 'package:dartz/dartz.dart';
import '../../entities/chat/chat_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class LoadShopChatRoomsUseCase {
  final ChatRepository repository;
  LoadShopChatRoomsUseCase(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) {
    return repository.getShopChatRooms(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isActive: isActive,
    );
  }
}