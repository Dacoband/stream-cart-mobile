import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class LoadChatRoomMessagesUseCase {
  final ChatRepository repository;

  LoadChatRoomMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(LoadChatRoomMessagesParams params) async {
    return await repository.getChatRoomMessages(
      params.chatRoomId,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
    );
  }
}

class LoadChatRoomMessagesParams extends Equatable {
  final String chatRoomId;
  final int pageNumber;
  final int pageSize;

  const LoadChatRoomMessagesParams({
    required this.chatRoomId,
    this.pageNumber = 1,
    this.pageSize = 50,
  });

  @override
  List<Object> get props => [chatRoomId, pageNumber, pageSize];
}