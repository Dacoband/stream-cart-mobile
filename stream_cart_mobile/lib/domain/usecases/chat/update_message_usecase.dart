import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class UpdateMessageUseCase {
  final ChatRepository repository;

  UpdateMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessage>> call(UpdateMessageParams params) async {
    return await repository.updateMessage(
      messageId: params.messageId,
      content: params.content,
    );
  }
}

class UpdateMessageParams extends Equatable {
  final String messageId;
  final String content;

  const UpdateMessageParams({
    required this.messageId,
    required this.content,
  });

  @override
  List<Object> get props => [messageId, content];
}