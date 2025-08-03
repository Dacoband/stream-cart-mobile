import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_message_entity.dart';
import '../../../core/error/failures.dart';

class ReceiveMessageUseCase {
  ReceiveMessageUseCase();

  Future<Either<Failure, ChatMessage>> call(ReceiveMessageParams params) async {
    try {
      // Process incoming message data
      final message = ChatMessage(
        id: params.messageData['id'] ?? '',
        chatRoomId: params.messageData['chatRoomId'] ?? '',
        senderUserId: params.messageData['senderUserId'] ?? '',
        content: params.messageData['content'] ?? '',
        sentAt: DateTime.tryParse(params.messageData['sentAt'] ?? '') ?? DateTime.now(),
        isRead: params.messageData['isRead'] ?? false,
        isEdited: params.messageData['isEdited'] ?? false,
        messageType: params.messageData['messageType'] ?? 'Text',
        attachmentUrl: params.messageData['attachmentUrl'],
        editedAt: params.messageData['editedAt'] != null 
            ? DateTime.tryParse(params.messageData['editedAt']) 
            : null,
        senderName: params.messageData['senderName'] ?? '',
        senderAvatarUrl: params.messageData['senderAvatarUrl'],
        isMine: params.messageData['isMine'] ?? false,
      );

      return Right(message);
    } catch (e) {
      return Left(ServerFailure('Failed to process received message: $e'));
    }
  }
}

class ReceiveMessageParams extends Equatable {
  final Map<String, dynamic> messageData;

  const ReceiveMessageParams({required this.messageData});

  @override
  List<Object> get props => [messageData];
}