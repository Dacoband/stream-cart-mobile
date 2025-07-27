import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';

import '../../../core/error/failures.dart';

class ReceiveMessageUseCase {
  Future<Either<Failure, ChatMessage>> call({
    required String message,
    required String senderId,
    String? chatRoomId,
    String? senderName,
    bool? isMine,
  }) async {
    try {
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
      // Có thể thêm logic async (ví dụ: kiểm tra với repository)
      return Right(newMessage);
    } catch (e) {
      return Left(ServerFailure('Lỗi tạo tin nhắn: ${e.toString()}'));
    }
  }
}