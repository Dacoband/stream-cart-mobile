import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/signalr_service.dart';

class LeaveChatRoomUseCase {
  final SignalRService signalRService;

  LeaveChatRoomUseCase(this.signalRService);

  Future<Either<Failure, void>> call(LeaveChatRoomParams params) async {
    try {
      await signalRService.leaveRoom(params.chatRoomId);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Failed to leave chat room: $e'));
    }
  }
}

class LeaveChatRoomParams extends Equatable {
  final String chatRoomId;

  const LeaveChatRoomParams({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}