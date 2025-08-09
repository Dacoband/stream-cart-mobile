import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/chat/chat_message_entity.dart';
import '../../../core/error/failures.dart';

class ReceiveMessageUseCase {
  ReceiveMessageUseCase();

  Future<Either<Failure, ChatMessage>> call(ReceiveMessageParams params) async {
    try {
      final data = params.messageData;

      T getFirst<T>(List<String> keys, {T? or}) {
        for (final k in keys) {
          if (data.containsKey(k) && data[k] != null) {
            return data[k] as T;
          }
        }
        return or as T;
      }

  String str(List<String> keys, {String def = ''}) => getFirst<String>(keys, or: def);
  bool boolVal(List<String> keys, {bool def = false}) => getFirst<bool>(keys, or: def);

      DateTime parseDate(List<String> keys) {
        final raw = str(keys);
        if (raw.isEmpty) return DateTime.now();
        return DateTime.tryParse(raw) ?? DateTime.now();
      }

      final message = ChatMessage(
        id: str(['id','Id','messageId','MessageId']),
        chatRoomId: str(['chatRoomId','ChatRoomId','roomId','RoomId']),
        senderUserId: str(['senderUserId','SenderUserId','userId','UserId','fromUserId','FromUserId']),
        content: str(['content','Content','message','Message','body','Body']),
        sentAt: parseDate(['sentAt','SentAt','createdAt','CreatedAt','timestamp','Timestamp']),
        isRead: boolVal(['isRead','IsRead','read','Read']),
        isEdited: boolVal(['isEdited','IsEdited','edited','Edited']),
        messageType: str(['messageType','MessageType','type','Type'], def: 'Text'),
        attachmentUrl: getFirst<String?>(['attachmentUrl','AttachmentUrl','fileUrl','FileUrl'], or: null),
        editedAt: () {
          final raw = str(['editedAt','EditedAt','updatedAt','UpdatedAt']);
            if (raw.isEmpty) return null;
            return DateTime.tryParse(raw);
        }(),
        senderName: str(['senderName','SenderName','fromName','FromName','userName','UserName']),
        senderAvatarUrl: getFirst<String?>(['senderAvatarUrl','SenderAvatarUrl','avatar','Avatar'], or: null),
        isMine: boolVal(['isMine','IsMine','mine','Mine']),
      );

      return Right(message);
    } catch (e) {
      return Left(ServerFailure('Failed to process received message: $e'));
    }
  }
}

class ReceiveMessageParams extends Equatable {
  final Map<String, dynamic> messageData;

  const ReceiveMessageParams({required this.messageData});

  @override
  List<Object> get props => [messageData];
}