import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class MarkChatRoomAsReadUseCase {
  final ChatRepository repository;

  MarkChatRoomAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(MarkChatRoomAsReadParams params) async {
    return await repository.markChatRoomAsRead(params.chatRoomId);
  }
}

class MarkChatRoomAsReadParams extends Equatable {
  final String chatRoomId;

  const MarkChatRoomAsReadParams({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}