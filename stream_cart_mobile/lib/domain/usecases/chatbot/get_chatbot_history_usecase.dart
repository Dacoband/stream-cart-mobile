import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/chatbot/chat_bot_entity.dart';
import '../../repositories/chatbot/chat_bot_repository.dart';

class GetChatBotHistoryUseCase {
  final ChatBotRepository repository;

  GetChatBotHistoryUseCase(this.repository);

  Future<Either<Failure, ChatBotHistoryEntity>> call() async {
    return await repository.getHistory();
  }
}
