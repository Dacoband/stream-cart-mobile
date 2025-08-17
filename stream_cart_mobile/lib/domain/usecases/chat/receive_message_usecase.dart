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

      dynamic anyVal(List<String> keys, {dynamic or}) {
        for (final k in keys) {
          if (data.containsKey(k) && data[k] != null) {
            return data[k];
          }
        }
        return or;
      }

      String str(List<String> keys, {String def = ''}) => getFirst<String>(keys, or: def);
      bool boolVal(List<String> keys, {bool def = false}) => getFirst<bool>(keys, or: def);

      DateTime parseDate(List<String> keys) {
        final rawAny = anyVal(keys);
        if (rawAny == null) return DateTime.now();
        if (rawAny is num) {
          final v = rawAny.toInt();
          final isMs = v.abs() >= 1000000000000;
          return DateTime.fromMillisecondsSinceEpoch(isMs ? v : v * 1000, isUtc: false);
        }
        final raw = rawAny.toString();
        if (raw.isEmpty) return DateTime.now();
        // Try ISO8601
        final parsed = DateTime.tryParse(raw);
        if (parsed != null) return parsed;
        // Try int parse fallback
        final asInt = int.tryParse(raw);
        if (asInt != null) {
          final isMs = raw.length >= 12;
          return DateTime.fromMillisecondsSinceEpoch(isMs ? asInt : asInt * 1000, isUtc: false);
        }
        return DateTime.now();
      }

      final message = ChatMessage(
        id: str(['id','Id','messageId','MessageId','messageID','MessageID']),
        chatRoomId: str([
          'chatRoomId','ChatRoomId','chatroomId','ChatroomId','chatRoomID','ChatRoomID',
          'roomId','RoomId','roomID','RoomID'
        ]),
        senderUserId: str([
          'senderUserId','SenderUserId','userId','UserId','fromUserId','FromUserId',
          'senderId','SenderId'
        ]),
        content: str(['content','Content','message','Message','body','Body','messageText','MessageText','MessageContent','messageContent']),
        sentAt: parseDate(['sentAt','SentAt','createdAt','CreatedAt','timestamp','Timestamp','createdOn','CreatedOn','sentOn','SentOn']),
        isRead: boolVal(['isRead','IsRead','read','Read']),
        isEdited: boolVal(['isEdited','IsEdited','edited','Edited']),
        messageType: str(['messageType','MessageType','type','Type'], def: 'Text'),
        attachmentUrl: getFirst<String?>(['attachmentUrl','AttachmentUrl','fileUrl','FileUrl','AttachmentURL','attachmentURL'], or: null),
        editedAt: () {
          final raw = str(['editedAt','EditedAt','updatedAt','UpdatedAt','editedOn','EditedOn']);
            if (raw.isEmpty) return null;
            return DateTime.tryParse(raw);
        }(),
        senderName: str(['senderName','SenderName','fromName','FromName','userName','UserName','sender','Sender']),
        senderAvatarUrl: getFirst<String?>(['senderAvatarUrl','SenderAvatarUrl','avatar','Avatar','senderAvatar','SenderAvatar'], or: null),
        isMine: boolVal(['isMine','IsMine','mine','Mine','isSender','IsSender']),
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