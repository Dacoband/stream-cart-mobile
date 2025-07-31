// Cho phép người dùng nhập và gửi tin nhắn.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';

class ChatInputWidget extends StatefulWidget {


  const ChatInputWidget({
    super.key,
    required this.onSend, 
  });

  final Function(String) onSend; 

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 108, 218, 45).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: TextStyle(color: Colors.black87),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFB0F847)),
            onPressed: () {
              final message = textController.text.trim();
              if (message.isNotEmpty) {
                widget.onSend(message);
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}