import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class SearchChatRoomMessagesUseCase {
  final ChatRepository repository;

  SearchChatRoomMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(SearchChatRoomMessagesParams params) async {
    return await repository.searchChatRoomMessages(
      params.chatRoomId,
      searchTerm: params.searchTerm,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
    );
  }
}

class SearchChatRoomMessagesParams extends Equatable {
  final String chatRoomId;
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  const SearchChatRoomMessagesParams({
    required this.chatRoomId,
    required this.searchTerm,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [chatRoomId, searchTerm, pageNumber, pageSize];
}