import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';
import '../../entities/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';

class ReceiveMessageUseCase {
  final ChatRepository repository;

  ReceiveMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessage>> call({
    required String message,
    required String senderId,
    String? chatRoomId,
    String? senderName,
    bool? isMine,
  }) {
    // Logic xử lý tin nhắn (có thể gọi repository hoặc tạo ChatMessage trực tiếp)
    final newMessage = ChatMessage(
      id: DateTime.now().toIso8601String(),
      chatRoomId: chatRoomId ?? '',
      senderUserId: senderId,
      content: message,
      sentAt: DateTime.now(),
      isRead: false,
      isEdited: false,
      messageType: 'Text',
      senderName: senderName ?? '',
      isMine: isMine ?? false,
    );
    return Future.value(Right(newMessage)); 
  }
}