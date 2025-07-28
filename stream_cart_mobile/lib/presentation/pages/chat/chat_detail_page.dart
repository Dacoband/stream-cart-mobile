import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../widgets/chat/chat_input_widget.dart';
import '../../widgets/chat/chat_message_list_widget.dart';
import '../../widgets/chat/livekit_status_widget.dart';
import '../../widgets/common/auth_guard.dart';

class ChatDetailPage extends StatefulWidget {
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
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  bool _hasConnected = false;

  @override
  void initState() {
    super.initState();
    // Chỉ phát ConnectLiveKit khi lần đầu vào phòng chat
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_hasConnected) {
        context.read<ChatBloc>().add(ConnectLiveKit(
          chatRoomId: widget.chatRoomId,
          userId: widget.userId,
          userName: widget.userName,
        ));
        _hasConnected = true;
      }
    });
  }

  @override
  void dispose() {
    // Khi rời phòng chat, phát DisconnectLiveKit
    context.read<ChatBloc>().add(DisconnectLiveKit());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      message: 'Vui lòng đăng nhập để vào phòng chat',
      child: WillPopScope(
        onWillPop: () async {
          context.read<ChatBloc>().add(DisconnectLiveKit());
          return true;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Phòng Chat', style: TextStyle(fontSize: 16))),
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(child: ChatMessageListWidget()),
                  // Hiển thị nút Thử lại khi gặp lỗi kết nối hoặc reconnect failed
                  if (state is ChatReconnectFailed || state is ChatError)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ChatBloc>().add(
                            ConnectLiveKit(
                              chatRoomId: widget.chatRoomId,
                              userId: widget.userId,
                              userName: widget.userName,
                            ),
                          );
                        },
                        child: const Text('Thử lại'),
                      ),
                    ),
                  LiveKitStatusWidget(),
                  ChatInputWidget(chatRoomId: widget.chatRoomId, userName: widget.userName),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}