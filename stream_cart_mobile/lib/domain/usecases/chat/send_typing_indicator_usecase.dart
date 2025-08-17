import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class SendTypingIndicatorUseCase {
  final ChatRepository repository;

  SendTypingIndicatorUseCase(this.repository);

  Future<Either<Failure, void>> call(SendTypingIndicatorParams params) async {
    return await repository.sendTypingIndicator(params.chatRoomId, params.isTyping);
  }
}

class SendTypingIndicatorParams extends Equatable {
  final String chatRoomId;
  final bool isTyping;

  const SendTypingIndicatorParams({
    required this.chatRoomId,
    required this.isTyping,
  });

  @override
  List<Object> get props => [chatRoomId, isTyping];
}