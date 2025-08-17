import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../entities/chatbot/chat_bot_entity.dart';
import '../../repositories/chatbot/chat_bot_repository.dart';

class SendChatBotMessageUseCase {
  final ChatBotRepository repository;

  SendChatBotMessageUseCase(this.repository);

  Future<Either<Failure, ChatBotMessageResponseEntity>> call(SendChatBotMessageParams params) async {
    return await repository.sendMessage(message: params.message);
  }
}

class SendChatBotMessageParams extends Equatable {
  final String message;

  const SendChatBotMessageParams({required this.message});

  @override
  List<Object?> get props => [message];
}
