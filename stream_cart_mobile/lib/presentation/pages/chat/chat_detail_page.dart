import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';

import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/usecases/chat/connect_livekit_usecase.dart';
import '../../../domain/usecases/chat/disconnect_livekit_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_usecase.dart';
import '../../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../../domain/usecases/chat/receive_message_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../blocs/chat/chat_state.dart';
import '../../widgets/common/auth_guard.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatRoomId;
  final String userId;
  final String userName;

  ChatDetailPage({
    required this.chatRoomId,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context){
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
            appBar: AppBar(title: Text('Phòng Chat')),
            body: Column(
              children: [
                Expanded(child: ChatMessageListWidget(chatRoomId: chatRoomId)),
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
class ChatMessageListWidget extends StatefulWidget {
  final String chatRoomId;
  const ChatMessageListWidget({required this.chatRoomId});
  @override
  _ChatMessageListWidgetState createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(0); 
          });
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) return Center(child: CircularProgressIndicator());
          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () => context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId)),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (state is ChatLoaded) {
            return ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                return ChatMessageItemWidget(message: state.messages[index]);
              },
            );
          }
          return Center(child: Text('Không có tin nhắn'));
        },
      ),
    );
  }
}

class ChatMessageItemWidget extends StatelessWidget {
  final ChatMessage message;

  ChatMessageItemWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.senderName),
            Text(message.content),
            Text(message.sentAt.toString()),
          ],
        ),
      ),
    );
  }
}

class ChatInputWidget extends StatelessWidget {
  final String chatRoomId;
  final String userName;

  ChatInputWidget({required this.chatRoomId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(hintText: 'Nhập tin nhắn...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final message = textController.text.trim();
              if (message.isNotEmpty) {
                context.read<ChatBloc>().add(SendMessage(
                  chatRoomId: chatRoomId,
                  message: message,
                ));
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class LiveKitStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is LiveKitConnected) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đang kết nối: ${state.chatRoomId}'),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => context.read<ChatBloc>().add(DisconnectLiveKit()),
                  color: Colors.red,
                ),
              ],
            ),
          );
        }
        if (state is LiveKitDisconnected) return Text('Ngắt kết nối');
        return SizedBox.shrink();
      },
    );
  }
}