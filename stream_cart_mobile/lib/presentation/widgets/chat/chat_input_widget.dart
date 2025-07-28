// Cho phép người dùng nhập và gửi tin nhắn.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';

class ChatInputWidget extends StatelessWidget {
  final String chatRoomId;
  final String userName;

  const ChatInputWidget({
    super.key,
    required this.chatRoomId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: TextStyle(color: Colors.grey.shade300),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFB0F847)),
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