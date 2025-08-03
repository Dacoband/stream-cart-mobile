import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessage>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      chatRoomId: params.chatRoomId,
      content: params.content,
      messageType: params.messageType,
      attachmentUrl: params.attachmentUrl,
    );
  }
}

class SendMessageParams extends Equatable {
  final String chatRoomId;
  final String content;
  final String messageType;
  final String? attachmentUrl;

  const SendMessageParams({
    required this.chatRoomId,
    required this.content,
    this.messageType = 'Text',
    this.attachmentUrl,
  });

  @override
  List<Object?> get props => [chatRoomId, content, messageType, attachmentUrl];
}