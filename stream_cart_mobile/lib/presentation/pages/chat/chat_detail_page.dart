import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/services/signalr_service.dart';
import '../../widgets/chat/chat_input_widget.dart';
import '../../widgets/chat/chat_message_list_widget.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatRoomId;
  final String userId;
  final String userName;

  const ChatDetailPage({
    super.key,
    required this.chatRoomId,
    required this.userId,
    required this.userName,
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
    
    try {
      getIt<LivekitService>().setChatBloc(context.read<ChatBloc>());
    } catch (e) {
      print('Error setting ChatBloc to LivekitService: $e');
    }
    
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
      context.read<ChatBloc>().add(MarkChatRoomAsRead(widget.chatRoomId));
    }
  }

  void _initializeChatRoom() {
    final currentState = context.read<ChatBloc>().state;    
    if (currentState is ChatLoaded && currentState.chatRoomId == widget.chatRoomId) {
      context.read<ChatBloc>().add(MarkChatRoomAsRead(widget.chatRoomId));
      return;
    }
    
    context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
    
    if (currentState is! LiveKitConnected) {
      context.read<ChatBloc>().add(ConnectLiveKit(
        chatRoomId: widget.chatRoomId,
        userId: widget.userId,
        userName: widget.userName,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tùy chỉnh back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB0F847)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Tùy chỉnh title (room name)
        title: Text(
          widget.userName,
          style: const TextStyle(
            color: Color(0xFFB0F847),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Tùy chỉnh background và elevation
        backgroundColor: Color(0xFF202328),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.1),
        
        // Tùy chỉnh actions (connection status)
        actions: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is LiveKitConnected || state is ChatStatusChanged) {
                if (state is ChatStatusChanged && 
                    (state.status.contains('✅') || state.status.contains('Đã kết nối'))) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
                  );
                } else if (state is LiveKitConnected) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          // menu nút actions
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFB0F847)),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
        
        // Tùy chỉnh bottom border
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
          // Auto mark as read khi load chat thành công
          if (state is ChatLoaded && 
              state.chatRoomId == widget.chatRoomId && 
              state.hasUnreadMessages) {
            context.read<ChatBloc>().add(MarkChatRoomAsRead(widget.chatRoomId));
          }
          
          if (state is ChatStatusChanged && 
              (state.status.contains('✅') || state.status.contains('Đã kết nối'))) {
            print('🔄 Connection successful, loading messages...');
            Future.delayed(const Duration(milliseconds: 500), () {
              context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
            });
          }
          
          if (state is LiveKitConnected) {
            Future.delayed(const Duration(milliseconds: 500), () {
              context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
            });
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            
            if (state is ChatLoading) {
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
            
            if (state is ChatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Lỗi: ${state.message}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }
            if (state is ChatStatusChanged) {
              if (state.status.contains('🔄') || state.status.contains('Đang')) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Đang kết nối...'),
                    ],
                  ),
                );
              } else if (state.status.contains('✅') || state.status.contains('Đã kết nối')) {
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
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, size: 64, color: Colors.orange),
                      SizedBox(height: 16),
                      Text(state.status),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }
            }
            
            if (state is ChatLoaded) {
              if (state.chatRoomId != null && state.chatRoomId != widget.chatRoomId) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
                });
                return const Center(child: CircularProgressIndicator());
              }       
              return Column(
                children: [
                  Expanded(
                    child: state.messages.isEmpty 
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('Chưa có tin nhắn nào'),
                              Text('Hãy bắt đầu cuộc trò chuyện!'),
                            ],
                          ),
                        )
                      : const ChatMessageListWidget(),
                  ),
                  ChatInputWidget(
                    onSend: (content) {
                      context.read<ChatBloc>().add(SendMessage(
                        chatRoomId: widget.chatRoomId,
                        message: content,
                      ));
                    },
                  ),
                ],
              );
            }
            
            // Default case - try to load messages
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
            });
            
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang khởi tạo...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}