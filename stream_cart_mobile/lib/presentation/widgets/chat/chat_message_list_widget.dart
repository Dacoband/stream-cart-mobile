// Hiển thị danh sách tin nhắn (ListView của ChatMessage).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/domain/entities/chat/chat_message_entity.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import '../../blocs/chat/chat_event.dart';
import '../common/error_widget.dart';
import '../common/loading_widget.dart';

class ChatMessageListWidget extends StatefulWidget {
  final String? chatRoomId; 
  const ChatMessageListWidget({super.key, this.chatRoomId});

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

  void _retryLoadMessages() {
    if (widget.chatRoomId != null) {
      context.read<ChatBloc>().add(LoadChatRoomMessagesEvent(
        chatRoomId: widget.chatRoomId!,
        pageNumber: 1,
        pageSize: 50,
        isRefresh: true,
      ));
    } else {
      // Try to get chatRoomId from current state
      final currentState = context.read<ChatBloc>().state;
      String? chatRoomId;
      
      // Fix: Check different possible state types
      if (currentState is ChatRoomDetailLoaded) {
        // Try different possible property names
        chatRoomId = (currentState as dynamic).chatRoom?.id ?? 
                    (currentState as dynamic).detail?.id ??
                    (currentState as dynamic).roomDetail?.id;
      } else if (currentState is ChatRoomJoined) {
        chatRoomId = currentState.chatRoomId;
      } else if (currentState is ChatMessagesLoaded) {
        // Get from previous loaded messages context
        chatRoomId = (currentState as dynamic).chatRoomId;
      }
      
      if (chatRoomId != null) {
        context.read<ChatBloc>().add(LoadChatRoomMessagesEvent(
          chatRoomId: chatRoomId,
          pageNumber: 1,
          pageSize: 50,
          isRefresh: true,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải lại tin nhắn. Vui lòng thử lại sau.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔄 ChatMessageListWidget build called for room: ${widget.chatRoomId}');
    
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        print('🎯 ChatMessageListWidget listener - State: ${state.runtimeType}');
        
        // Auto scroll when messages loaded
        if (state is ChatMessagesLoaded) {
          print('✅ Messages loaded in listener: ${state.messages.length}');
          print('📍 For room: ${state.chatRoomId}');
          print('📱 Widget room: ${widget.chatRoomId}');
          
          _hasScrolledToBottom = false;
          if (state.messages.isNotEmpty) {
            _scrollToBottom();
          }
        }
        // Auto scroll when new message received
        if (state is MessageReceived) {
          _scrollToBottom();
        }
        // Auto scroll when typing indicator shows
        if (state is TypingIndicatorReceived && state.isTyping) {
          _scrollToBottom();
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          print('🏗️ ChatMessageListWidget builder - State: ${state.runtimeType}');
          
          if (state is ChatMessagesLoading) {
            print('⏳ Loading messages...');
            return const CustomLoadingWidget();
          }
          
          if (state is ChatMessagesError) {
            print('❌ Messages error: ${state.message}');
            return CustomErrorWidget(
              message: state.message,
              onRetry: _retryLoadMessages, // Use the fixed retry method
            );
          }
          
          if (state is ChatMessagesLoaded) {
            print('✅ Building messages list with ${state.messages.length} messages');
            print('📍 State room ID: ${state.chatRoomId}');
            print('📱 Widget room ID: ${widget.chatRoomId}');
            
            // Check if messages are for this widget's room
            if (widget.chatRoomId != null && state.chatRoomId != widget.chatRoomId) {
              print('❌ Room IDs don\'t match - not displaying');
              return const Center(
                child: Text('Chưa có tin nhắn. Hãy gửi tin nhắn đầu tiên!'),
              );
            }
            if (state.messages.isEmpty) {
              return Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Chưa có tin nhắn nào'),
                          Text('Hãy bắt đầu cuộc trò chuyện!'),
                        ],
                      ),
                    ),
                  ),
                  // Typing indicator for empty chat
                  _buildTypingIndicator(),
                ],
              );
            }

            final sortedMessages = List<ChatMessage>.from(state.messages)
              ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
            
            // Auto scroll when build finished
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_hasScrolledToBottom && _scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                _hasScrolledToBottom = true;
              }
            });
            
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: sortedMessages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageItemWidget(message: sortedMessages[index]);
                    },
                  ),
                ),
                // Typing indicator at bottom of messages
                _buildTypingIndicator(),
              ],
            );
          }
          
          // Handle SignalR connection states
          if (state is SignalRConnected) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải tin nhắn...'),
                ],
              ),
            );
          }
          
          if (state is SignalRConnecting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang kết nối chat...'),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              const Expanded(
                child: Center(child: Text('Chưa có tin nhắn. Hãy gửi tin nhắn đầu tiên!')),
              ),
              _buildTypingIndicator(),
            ],
          );
        },
      ),
    );
  }

  // NEW: Typing Indicator Widget
  Widget _buildTypingIndicator() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        // Show typing indicator when someone else is typing
        if (state is TypingIndicatorReceived && state.isTyping) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Animated typing dots
                SizedBox(
                  width: 24,
                  height: 24,
                  child: _buildTypingAnimation(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${state.userName ?? "Đối phương"} đang nhập...',
                    style: TextStyle(
                      color: Colors.grey[600], 
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                // Optional: Show for how long they've been typing
                Text(
                  _getTypingDuration(state.timestamp),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Animated typing dots
  Widget _buildTypingAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animatedValue = (value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * (1 - (animatedValue - 0.5).abs() * 2).clamp(0.0, 1.0));
            
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
      onEnd: () {
        // Restart animation if still typing
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  String _getTypingDuration(DateTime? startTime) {
    if (startTime == null) return '';
    final duration = DateTime.now().difference(startTime);
    if (duration.inSeconds < 5) return '';
    return '${duration.inSeconds}s';
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
                      (message.senderName?.isNotEmpty == true)
                          ? message.senderName![0].toUpperCase()
                          : '?', // Default fallback
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                      // Message status indicator for sent messages
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead 
                              ? Icons.done_all 
                              : Icons.done,
                          size: 12,
                          color: message.isRead 
                              ? Colors.blue 
                              : Colors.black.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
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