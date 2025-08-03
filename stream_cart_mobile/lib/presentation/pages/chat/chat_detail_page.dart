import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import '../../widgets/chat/chat_input_widget.dart';
import '../../widgets/chat/chat_message_list_widget.dart';
import '../../widgets/chat/signalr_status_widget.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatRoomId;
  final String shopId;
  final String shopName;

  const ChatDetailPage({
    super.key,
    required this.chatRoomId,
    required this.shopId,
    required this.shopName,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> with WidgetsBindingObserver {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _initializeChatRoom();
        _hasInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); 
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ChatBloc>().add(MarkChatRoomAsReadEvent(
        chatRoomId: widget.chatRoomId,
      ));
    }
  }

  void _initializeChatRoom() {
    // Ensure SignalR is connected first
    context.read<ChatBloc>().add(const ConnectSignalREvent());
    
    // Join chat room
    context.read<ChatBloc>().add(JoinChatRoomEvent(
      chatRoomId: widget.chatRoomId,
    ));
    
    // Load chat room detail
    context.read<ChatBloc>().add(LoadChatRoomDetailEvent(
      chatRoomId: widget.chatRoomId,
    ));
    
    // Load messages
    context.read<ChatBloc>().add(LoadChatRoomMessagesEvent(
      chatRoomId: widget.chatRoomId,
      pageNumber: 1,
      pageSize: 50,
      isRefresh: true,
    ));
    
    // Mark as read
    context.read<ChatBloc>().add(MarkChatRoomAsReadEvent(
      chatRoomId: widget.chatRoomId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Giữ nguyên UI design của bạn
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0F847)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.shopName,
          style: const TextStyle(
            color: Color(0xFFB0F847),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF202328),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.1),
        actions: [
          // Connection status indicator
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is SignalRConnected || state is ChatRoomJoined) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.circle, color: Colors.green, size: 12),
                );
              } else if (state is SignalRConnecting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB0F847)),
                    ),
                  ),
                );
              } else if (state is SignalRConnectionError) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.circle, color: Colors.red, size: 12),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFB0F847)),
            onPressed: () {
              // Handle menu action
              _showChatOptions(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          // Auto mark as read when messages loaded
          if (state is ChatMessagesLoaded) {
            context.read<ChatBloc>().add(MarkChatRoomAsReadEvent(
              chatRoomId: widget.chatRoomId,
            ));
          }
          
          // Handle connection success
          if (state is SignalRConnected) {
            print('🔄 SignalR connected, joining room and loading messages...');
            Future.delayed(const Duration(milliseconds: 500), () {
              context.read<ChatBloc>().add(JoinChatRoomEvent(
                chatRoomId: widget.chatRoomId,
              ));
            });
          }
          
          if (state is ChatRoomJoined) {
            print('🏠 Joined room, loading messages...');
            Future.delayed(const Duration(milliseconds: 300), () {
              context.read<ChatBloc>().add(LoadChatRoomMessagesEvent(
                chatRoomId: widget.chatRoomId,
                pageNumber: 1,
                pageSize: 50,
                isRefresh: true,
              ));
            });
          }
        },
        child: Column(
          children: [
            // SignalR Status Widget
            const SignalRStatusWidget(),
            
            // Messages List
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatMessagesLoading || state is SignalRConnecting) {
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
                  
                  if (state is ChatMessagesError || state is SignalRConnectionError) {
                    final errorMessage = state is ChatMessagesError 
                        ? state.message 
                        : (state as SignalRConnectionError).error;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Lỗi: $errorMessage'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _initializeChatRoom(),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }
                  final chatRoomId = widget.chatRoomId;
                  return ChatMessageListWidget(chatRoomId: chatRoomId);
                },
              ),
            ),
            
            // Chat Input
            Container(
              padding: const EdgeInsets.all(8.0),
              child: ChatInputWidget(
                chatRoomId: widget.chatRoomId,
                onSend: (content) {
                  context.read<ChatBloc>().add(SendMessageEvent(
                    chatRoomId: widget.chatRoomId,
                    content: content,
                    messageType: 'text',
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Tìm kiếm tin nhắn'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to search messages
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Tải lại tin nhắn'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ChatBloc>().add(LoadChatRoomMessagesEvent(
                    chatRoomId: widget.chatRoomId,
                    pageNumber: 1,
                    pageSize: 50,
                    isRefresh: true,
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Thông tin shop'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to shop info
                },
              ),
            ],
          ),
        );
      },
    );
  }
}