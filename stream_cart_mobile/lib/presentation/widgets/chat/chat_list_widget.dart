// Hiển thị danh sách phòng chat (ListView của ChatEntity).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import '../../pages/chat/chat_detail_page.dart';
import 'package:stream_cart_mobile/domain/entities/chat_entity.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';

class ChatListWidget extends StatelessWidget {
  final List<ChatEntity> chatRooms;

  const ChatListWidget({super.key, required this.chatRooms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFB0F847).withOpacity(0.2),
                child: Text(
                  chatRoom.shopName?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(color: Color(0xFFB0F847)),
                ),
              ),
              // Unread indicator 
              if (chatRoom.hasUnreadMessages)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  chatRoom.shopName,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: chatRoom.hasUnreadMessages 
                        ? FontWeight.bold 
                        : FontWeight.w600, 
                  ),
                ),
              ),
              // Unread count badge
              if (chatRoom.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    chatRoom.unreadCount > 99 ? '99+' : '${chatRoom.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Text(
            chatRoom.lastMessage?.content ?? 'Chưa có tin nhắn',
            style: TextStyle(
              color: chatRoom.hasUnreadMessages ? Colors.black87 : Colors.black54,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              fontWeight: chatRoom.hasUnreadMessages ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (chatRoom.lastMessage != null)
                Text(
                  _formatTime(chatRoom.lastMessageAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: chatRoom.hasUnreadMessages 
                        ? Colors.black87 
                        : Colors.grey[500],
                    fontWeight: chatRoom.hasUnreadMessages 
                        ? FontWeight.w500 
                        : FontWeight.normal,
                  ),
                ),
            ],
          ),
          onTap: () {
            final authState = context.read<AuthBloc>().state;
            String? userId;
            String? userName;
            
            if (authState is AuthSuccess) {
              userId = authState.loginResponse.account.id;
              userName = authState.loginResponse.account.username;
            }
            if (userId == null || chatRoom.id.isEmpty) {
              return;
            }
            context.read<ChatBloc>().add(SwitchChatRoom(
              chatRoomId: chatRoom.id,
              userId: userId,
              userName: userName.toString(),
            ));

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ChatBloc>(context),
                  child: ChatDetailPage(
                    chatRoomId: chatRoom.id,
                    userId: chatRoom.userId,
                    userName: chatRoom.userName,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}