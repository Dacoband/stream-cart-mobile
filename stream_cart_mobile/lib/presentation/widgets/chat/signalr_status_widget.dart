import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';

class SignalRStatusWidget extends StatelessWidget {
  const SignalRStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is SignalRConnecting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.orange.withOpacity(0.1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Đang kết nối chat...',
                  style: TextStyle(color: Colors.orange, fontSize: 14),
                ),
              ],
            ),
          );
        }
        
        if (state is SignalRConnected) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.green.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Chat đã kết nối',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<ChatBloc>().add(const DisconnectSignalREvent());
                  },
                  child: const Text(
                    'Ngắt kết nối',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }
        
        if (state is SignalRConnectionError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.red.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lỗi kết nối: ${state.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ChatBloc>().add(const ConnectSignalREvent());
                  },
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }
        
        if (state is SignalRReconnecting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.blue.withOpacity(0.1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Đang kết nối lại...',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
            ),
          );
        }
        
        if (state is ChatRoomJoined) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: const Color(0xFFB0F847).withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.chat, color: Color(0xFFB0F847), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đã vào phòng chat: ${state.chatRoomId}',
                    style: const TextStyle(color: Color(0xFFB0F847), fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ChatBloc>().add(LeaveChatRoomEvent(
                      chatRoomId: state.chatRoomId,
                    ));
                  },
                  child: const Text(
                    'Rời phòng',
                    style: TextStyle(color: Color(0xFFB0F847), fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ChatRoomLeft) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            color: Colors.grey.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  'Đã rời phòng chat',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          );
        }
        if (state is TypingIndicatorSent) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.grey.withOpacity(0.1),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Đang nhập tin nhắn...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          );
        }

        // Message states
        if (state is MessageSent) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            color: Colors.green.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.check, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Tin nhắn đã gửi',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (state is MessageReceived) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            color: const Color(0xFFB0F847).withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.message, color: Color(0xFFB0F847), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Tin nhắn mới từ ${state.message.senderName}',
                  style: const TextStyle(color: Color(0xFFB0F847), fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }

        if (state is MessageSendError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.red.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lỗi gửi tin nhắn: ${state.message}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Could trigger retry send message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hãy thử gửi lại tin nhắn')),
                    );
                  },
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

        // Loading states
        if (state is ChatRoomsLoading) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.blue.withOpacity(0.1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Đang tải danh sách chat...',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (state is ChatMessagesLoading) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.blue.withOpacity(0.1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Đang tải tin nhắn...',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}