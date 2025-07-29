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
            // Scroll to bottom (latest message) smoother
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
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
            
            // Sắp xếp tin nhắn theo thời gian: cũ -> mới (tin nhắn mới nhất ở cuối)
            final sortedMessages = List<ChatMessage>.from(state.messages)
              ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
            
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
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFF2196F3) : const Color(0xFF424242),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMine ? 12 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sender name
            Text(
              message.senderName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isMine ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            // Message content
            Text(
              message.content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 4),
            // Timestamp
            Text(
              _formatTime(message.sentAt),
              style: TextStyle(
                fontSize: 11,
                color: isMine ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      // Today - show only time
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Other days - show date and time
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}