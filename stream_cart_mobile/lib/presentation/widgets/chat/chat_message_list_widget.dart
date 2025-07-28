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
            _scrollController.jumpTo(0); 
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
            return ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                return ChatMessageItemWidget(message: state.messages[index]);
              },
            );
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
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue[100] : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
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
          children: [
            Text(
              message.senderName,
              style: TextStyle(fontSize: 12, color: isMine ? Colors.blue[900] : Colors.white),
            ),
            Text(
              message.content,
              style: TextStyle(fontSize: 14, color: isMine ? Colors.black87 : Colors.white),
            ),
            Text(
              message.sentAt.toString().split('.')[0], 
              style: TextStyle(fontSize: 10, color: isMine ? Colors.blueGrey : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}