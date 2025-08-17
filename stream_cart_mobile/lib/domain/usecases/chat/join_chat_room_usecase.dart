import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/signalr_service.dart';

class JoinChatRoomUseCase {
  final SignalRService signalRService;

  JoinChatRoomUseCase(this.signalRService);

  Future<Either<Failure, void>> call(JoinChatRoomParams params) async {
    try {
  await signalRService.joinChatRoom(params.chatRoomId);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Failed to join chat room: $e'));
    }
  }
}

class JoinChatRoomParams extends Equatable {
  final String chatRoomId;

  const JoinChatRoomParams({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}