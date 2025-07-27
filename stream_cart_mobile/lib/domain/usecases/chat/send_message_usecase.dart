import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';
import '../../entities/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessage>> call({
    required String chatRoomId,
    required String content,
    String messageType = 'Text',
    String? attachmentUrl,
  }) {
    return repository.sendMessage(
      chatRoomId: chatRoomId,
      content: content,
      messageType: messageType,
      attachmentUrl: attachmentUrl,
    );
  }
}