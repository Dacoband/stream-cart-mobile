// Hiển thị danh sách phòng chat (ListView của ChatEntity).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import '../../pages/chat/chat_detail_page.dart';
import 'package:stream_cart_mobile/domain/entities/chat/chat_room_entity.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';

class ChatListWidget extends StatelessWidget {
  final List<ChatEntity> chatRooms;

  const ChatListWidget({super.key, required this.chatRooms});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0), 
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          return Container(
            color: Colors.white, 
            child: Card( 
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFB0F847).withOpacity(0.8),
                            const Color(0xFFB0F847).withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          chatRoom.shopName.isNotEmpty 
                              ? chatRoom.shopName.substring(0, 1).toUpperCase() 
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Unread indicator - red dot
                    if (chatRoom.hasUnreadMessages)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              chatRoom.unreadCount > 9 ? '9+' : '${chatRoom.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                          fontSize: 13,
                          fontWeight: chatRoom.hasUnreadMessages 
                              ? FontWeight.bold 
                              : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Time badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: chatRoom.hasUnreadMessages 
                            ? const Color(0xFFB0F847).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatTime(chatRoom.lastMessageAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: chatRoom.hasUnreadMessages 
                              ? const Color(0xFFB0F847)
                              : Colors.grey[600],
                          fontWeight: chatRoom.hasUnreadMessages 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(
                        chatRoom.hasUnreadMessages 
                            ? Icons.mark_chat_unread 
                            : Icons.mark_chat_read,
                        size: 14,
                        color: chatRoom.hasUnreadMessages 
                            ? Colors.orange 
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          chatRoom.lastMessage?.content ?? 'Chưa có tin nhắn',
                          style: TextStyle(
                            color: chatRoom.hasUnreadMessages 
                                ? Colors.black87 
                                : Colors.grey[600],
                            fontSize: 13,
                            fontWeight: chatRoom.hasUnreadMessages 
                                ? FontWeight.w500 
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
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
                  
                  // Add haptic feedback
                  // HapticFeedback.lightImpact();
                  
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
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}p';
    } else if (difference.inDays == 0) {
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