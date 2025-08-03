import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_room_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class CreateChatRoomUseCase {
  final ChatRepository repository;

  CreateChatRoomUseCase(this.repository);

  Future<Either<Failure, ChatRoomEntity>> call(CreateChatRoomParams params) async {
    return await repository.createChatRoom(
      shopId: params.shopId,
      relatedOrderId: params.relatedOrderId,
      initialMessage: params.initialMessage,
    );
  }
}

class CreateChatRoomParams extends Equatable {
  final String shopId;
  final String? relatedOrderId;
  final String initialMessage;

  const CreateChatRoomParams({
    required this.shopId,
    this.relatedOrderId,
    required this.initialMessage,
  });

  @override
  List<Object?> get props => [shopId, relatedOrderId, initialMessage];
}