import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_room_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class LoadChatRoomDetailUseCase {
  final ChatRepository repository;

  LoadChatRoomDetailUseCase(this.repository);

  Future<Either<Failure, ChatRoomEntity>> call(LoadChatRoomDetailParams params) async {
    return await repository.getChatRoomDetail(params.chatRoomId);
  }
}

class LoadChatRoomDetailParams extends Equatable {
  final String chatRoomId;

  const LoadChatRoomDetailParams({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}