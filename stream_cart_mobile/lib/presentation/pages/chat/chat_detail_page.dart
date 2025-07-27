import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';

import '../../../domain/usecases/chat/connect_livekit_usecase.dart';
import '../../../domain/usecases/chat/disconnect_livekit_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_usecase.dart';
import '../../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../../domain/usecases/chat/receive_message_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../widgets/chat/chat_input_widget.dart';
import '../../widgets/chat/chat_message_list_widget.dart';
import '../../widgets/chat/livekit_status_widget.dart';
import '../../widgets/common/auth_guard.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatRoomId;
  final String userId;
  final String userName;

  const ChatDetailPage({
    super.key,
    required this.chatRoomId,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      message: 'Vui lòng đăng nhập để vào phòng chat',
      child: BlocProvider(
        create: (context) => ChatBloc(
          loadChatRoomUseCase: context.read<LoadChatRoomUseCase>(),
          loadChatRoomsByShopUseCase: context.read<LoadChatRoomsByShopUseCase>(),
          loadChatRoomsUseCase: context.read<LoadChatRoomsUseCase>(),
          sendMessageUseCase: context.read<SendMessageUseCase>(),
          receiveMessageUseCase: context.read<ReceiveMessageUseCase>(),
          markChatRoomAsReadUseCase: context.read<MarkChatRoomAsReadUseCase>(),
          connectLiveKitUseCase: context.read<ConnectLiveKitUseCase>(),
          disconnectLiveKitUseCase: context.read<DisconnectLiveKitUseCase>(),
        )..add(LoadChatRoom(chatRoomId))..add(ConnectLiveKit(chatRoomId: chatRoomId, userId: userId, userName: userName)),
        child: WillPopScope(
          onWillPop: () async {
            context.read<ChatBloc>().add(DisconnectLiveKit());
            return true;
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('Phòng Chat')),
            body: Column(
              children: [
                Expanded(child: ChatMessageListWidget()),
                LiveKitStatusWidget(),
                ChatInputWidget(chatRoomId: chatRoomId, userName: userName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}