import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/chat_entity.dart';
import '../../repositories/chat_repository.dart';

class LoadChatRoomsByShopUseCase {
  final ChatRepository repository;

  LoadChatRoomsByShopUseCase(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call({
    required String shopId,
    int pageNumber = 1,
    int pageSize = 20,
  }) {
    return repository.getChatRoomsByShop(shopId, pageNumber: pageNumber, pageSize: pageSize);
  }
}