import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/services/livekit_service.dart';
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
    getIt<LivekitService>().setChatBloc(context.read<ChatBloc>());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_hasConnected) {
        // Load chat room messages trước
        context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
        
        // Sau đó connect LiveKit
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
    // context.read<ChatBloc>().add(const DisconnectLiveKit());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      message: 'Vui lòng đăng nhập để vào phòng chat',
      child: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            context.read<ChatBloc>().add(DisconnectLiveKit());
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Phòng Chat', style: TextStyle(fontSize: 16))),
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Hiển thị loading khi đang kết nối
                  if (state is ChatLoading)
                    const LinearProgressIndicator(),
                  
                  Expanded(child: ChatMessageListWidget()),
                  
                  // Hiển thị nút Thử lại khi gặp lỗi kết nối hoặc reconnect failed
                  if (state is ChatError && state.message.contains('LiveKit'))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '⚠️ ${state.message}',
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ChatBloc>().add(
                                  ConnectLiveKit(
                                    chatRoomId: widget.chatRoomId,
                                    userId: widget.userId,
                                    userName: widget.userName,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              ),
                              child: const Text('🔄 Thử lại kết nối'),
                            ),
                          ],
                        ),
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