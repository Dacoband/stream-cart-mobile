import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/services/livekit_service.dart';
import '../../widgets/chat/chat_input_widget.dart';
import '../../widgets/chat/chat_message_list_widget.dart';
import '../../widgets/chat/chat_message_widget.dart';
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

class _ChatDetailPageState extends State<ChatDetailPage> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Set ChatBloc to LivekitService
    try {
      getIt<LivekitService>().setChatBloc(context.read<ChatBloc>());
    } catch (e) {
      print('Error setting ChatBloc to LivekitService: $e');
    }
    
    // Initialize once
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _initializeChatRoom();
        _hasInitialized = true;
      }
    });
  }

  void _initializeChatRoom() {
    print('🚀 Initializing chat room: ${widget.chatRoomId}');
    
    // Kiểm tra current state
    final currentState = context.read<ChatBloc>().state;
    print('🔍 Current ChatBloc state: ${currentState.runtimeType}');
    
    if (currentState is ChatLoaded && currentState.chatRoomId == widget.chatRoomId) {
      print('✅ Room already loaded with ${currentState.messages.length} messages');
      return;
    }
    
    // Load messages first
    context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
    
    // Then check if we need to connect LiveKit
    if (currentState is! LiveKitConnected) {
      print('🔗 Connecting to LiveKit...');
      context.read<ChatBloc>().add(ConnectLiveKit(
        chatRoomId: widget.chatRoomId,
        userId: widget.userId,
        userName: widget.userName,
      ));
    }
  }

  @override
  void dispose() {
    // Don't disconnect LiveKit here - keep global connection
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        actions: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is LiveKitConnected || state is ChatStatusChanged) {
                // Check if connected from status message
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
        ],
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatStatusChanged && 
              (state.status.contains('✅') || state.status.contains('Đã kết nối'))) {
            print('🔄 Connection successful, loading messages...');
            Future.delayed(const Duration(milliseconds: 500), () {
              context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
            });
          }
          
          if (state is LiveKitConnected) {
            print('🔄 LiveKit connected, loading messages...');
            Future.delayed(const Duration(milliseconds: 500), () {
              context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
            });
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            print('🔍 ChatDetailPage - Current state: ${state.runtimeType}');
            
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
            
            // FIX: Handle ChatStatusChanged state
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
              // Kiểm tra xem có đúng room không
              if (state.chatRoomId != null && state.chatRoomId != widget.chatRoomId) {
                print('🔍 Wrong room loaded. Expected: ${widget.chatRoomId}, Got: ${state.chatRoomId}');
                // Load correct room
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ChatBloc>().add(LoadChatRoom(widget.chatRoomId));
                });
                return const Center(child: CircularProgressIndicator());
              }
              
              print('🔍 ChatDetailPage - Showing ${state.messages.length} messages for room: ${widget.chatRoomId}');
              
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
            print('🔍 Unknown state: ${state.runtimeType}, trying to load messages...');
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