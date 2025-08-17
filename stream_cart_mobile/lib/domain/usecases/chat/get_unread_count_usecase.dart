import 'package:dartz/dartz.dart';
import '../../entities/chat/unread_count_entity.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/error/failures.dart';

class GetUnreadCountUseCase {
  final ChatRepository repository;

  GetUnreadCountUseCase(this.repository);

  Future<Either<Failure, UnreadCountEntity>> call() async {
    return await repository.getUnreadCount();
  }
}