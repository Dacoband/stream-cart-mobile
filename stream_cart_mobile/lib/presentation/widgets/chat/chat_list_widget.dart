// Hiển thị danh sách phòng chat (ListView của ChatEntity).

import 'package:flutter/material.dart';
import 'package:stream_cart_mobile/domain/entities/chat_entity.dart';
import '../../pages/chat/chat_detail_page.dart';

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
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFB0F847).withOpacity(0.2),
            child: Text(
              chatRoom.shopName?.substring(0, 1).toUpperCase() ?? '?',
              style: const TextStyle(color: Color(0xFFB0F847)),
            ),
          ),
          title: Text(
            chatRoom.shopName ?? 'Không tên',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            chatRoom.lastMessage?.content ?? 'Chưa có tin nhắn',
            style: TextStyle(color: Colors.grey.shade400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: chatRoom.unreadCount != null && chatRoom.unreadCount! > 0
              ? CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    chatRoom.unreadCount! > 99 ? '99+' : chatRoom.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )
              : null,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(
                chatRoomId: chatRoom.id,
                userId: chatRoom.userId,
                userName: chatRoom.userName ?? 'Unknown',
              ),
            ),
          ),
        );
      },
    );
  }
}