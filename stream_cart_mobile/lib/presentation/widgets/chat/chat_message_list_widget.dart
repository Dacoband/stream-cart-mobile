// Hiển thị danh sách tin nhắn (ListView của ChatMessage).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import '../../blocs/chat/chat_event.dart';
import '../common/error_widget.dart';
import '../common/loading_widget.dart';

class ChatMessageListWidget extends StatefulWidget {
  const ChatMessageListWidget({super.key});

  @override
  _ChatMessageListWidgetState createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          _hasScrolledToBottom = false;
          if (state.messages.isNotEmpty) {
            _scrollToBottom();
          }
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) return const CustomLoadingWidget();
          if (state is ChatError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                final chatRoomId = (context.read<ChatBloc>().state is ChatLoaded)
                    ? (context.read<ChatBloc>().state as ChatLoaded).chatRoomId
                    : null;
                if (chatRoomId != null) context.read<ChatBloc>().add(LoadChatRoom(chatRoomId));
              },
            );
          }
          if (state is ChatLoaded) {
            if (state.messages.isEmpty) {
              return const Center(child: Text('Chưa có tin nhắn. Hãy gửi tin nhắn đầu tiên!'));
            }

            final sortedMessages = List<ChatMessage>.from(state.messages)
              ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
            
            // Auto scroll khi build xong
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_hasScrolledToBottom && _scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                _hasScrolledToBottom = true;
              }
            });
            
            return ListView.builder(
              controller: _scrollController,
              itemCount: sortedMessages.length,
              itemBuilder: (context, index) {
                // Hiển thị tin nhắn theo thứ tự thời gian (cũ -> mới)
                // Tin nhắn cũ nhất ở trên (index 0), tin nhắn mới nhất ở dưới (index cuối)
                return ChatMessageItemWidget(message: sortedMessages[index]);
              },
            );
          }
          // Handle các state khác như LiveKitConnected, ChatStatusChanged
          if (state is LiveKitConnected || state is ChatStatusChanged) {
            return const Center(child: Text('Đang tải tin nhắn...'));
          }
          return const Center(child: Text('Không có tin nhắn'));
        },
      ),
    );
  }
}

class ChatMessageItemWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageItemWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              backgroundImage: message.senderAvatarUrl != null && message.senderAvatarUrl!.isNotEmpty
                  ? NetworkImage(message.senderAvatarUrl!)
                  : null,
              child: message.senderAvatarUrl == null || message.senderAvatarUrl!.isEmpty
                  ? Text(
                      message.senderName.isNotEmpty 
                          ? message.senderName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
              minWidth: 60, 
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMine 
                    ? const Color(0xFFB0F847)
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine ? 16 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Message content
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMine ? Colors.black : Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  // Timestamp
                  Row(
                    mainAxisSize: MainAxisSize.min, 
                    mainAxisAlignment: isMine 
                        ? MainAxisAlignment.end 
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        _formatTime(message.sentAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMine 
                              ? Colors.black.withOpacity(0.6)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Avatar bên phải cho tin nhắn của mình
          // if (isMine) ...[
          //   const SizedBox(width: 8),
          //   CircleAvatar(
          //     radius: 16,
          //     backgroundColor: const Color(0xFFB0F847),
          //     backgroundImage: message.senderAvatarUrl != null && message.senderAvatarUrl!.isNotEmpty
          //         ? NetworkImage(message.senderAvatarUrl!)
          //         : null,
          //     child: message.senderAvatarUrl == null || message.senderAvatarUrl!.isEmpty
          //         ? Text(
          //             message.senderName.isNotEmpty 
          //                 ? message.senderName[0].toUpperCase()
          //                 : 'M',
          //             style: const TextStyle(
          //               fontSize: 12, 
          //               fontWeight: FontWeight.bold,
          //               color: Colors.black,
          //             ),
          //           )
          //         : null,
          //   ),
          // ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}