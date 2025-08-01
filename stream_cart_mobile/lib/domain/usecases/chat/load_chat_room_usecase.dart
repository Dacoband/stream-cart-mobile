import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';
import 'package:stream_cart_mobile/domain/repositories/chat_repository.dart';
import '../../entities/chat/chat_message_entity.dart';

class LoadChatRoomUseCase {
  final ChatRepository repository;

  LoadChatRoomUseCase(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(String chatRoomId) {
    return repository.getChatRoomMessages(chatRoomId);
  }
}