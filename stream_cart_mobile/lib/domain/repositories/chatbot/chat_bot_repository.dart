import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/chatbot/chat_bot_entity.dart';

abstract class ChatBotRepository {
	Future<Either<Failure, ChatBotHistoryEntity>> getHistory();
	Future<Either<Failure, ChatBotMessageResponseEntity>> sendMessage({required String message});
}

