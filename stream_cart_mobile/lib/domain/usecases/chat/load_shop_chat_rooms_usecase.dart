import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_room_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class LoadShopChatRoomsUseCase {
  final ChatRepository repository;

  LoadShopChatRoomsUseCase(this.repository);

  Future<Either<Failure, ChatRoomsPaginatedResponse>> call(LoadShopChatRoomsParams params) async {
    return await repository.getShopChatRooms(
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      isActive: params.isActive,
    );
  }
}

class LoadShopChatRoomsParams extends Equatable {
  final int pageNumber;
  final int pageSize;
  final bool? isActive;

  const LoadShopChatRoomsParams({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.isActive,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, isActive];
}