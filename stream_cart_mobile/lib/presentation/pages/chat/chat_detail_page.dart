import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/domain/entities/chat/chat_message_entity.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import 'package:stream_cart_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/auth/auth_state.dart';
import '../../widgets/chat/chat_input_widget.dart';
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
  List<ChatMessage> _cachedMessages = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    
    // Simplified initialization
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _initializeChatRoom();
        _hasInitialized = true;
      }
    });
  }

  void _initializeChatRoom() {
  // 1. Connect SignalR first
    context.read<ChatBloc>().add(const ConnectSignalREvent());
    
    // 2. Join room
    context.read<ChatBloc>().add(JoinChatRoomEvent(
      chatRoomId: widget.chatRoomId,
    ));
    
    // 3. Load chat room detail
    context.read<ChatBloc>().add(LoadChatRoomDetailEvent(
      chatRoomId: widget.chatRoomId,
    ));
    
    // 4. Load messages - MAIN CALL
    context.read<ChatBloc>().add(LoadChatRoomMessagesEvent(
      chatRoomId: widget.chatRoomId,
      pageNumber: 1,
      pageSize: 50,
      isRefresh: true,
    ));
    
    // 5. Mark as read
    context.read<ChatBloc>().add(MarkChatRoomAsReadEvent(
      chatRoomId: widget.chatRoomId,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  String? _getCurrentUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      return authState.loginResponse.account.id;
    }
    return null;
  }

  bool _isMyMessage(ChatMessage message) {
    final currentUserId = _getCurrentUserId();
    if (currentUserId == null) return message.isMine;
    final isActuallyMine = message.senderUserId == currentUserId;
    return isActuallyMine;
  }  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ChatBloc>().add(MarkChatRoomAsReadEvent(
        chatRoomId: widget.chatRoomId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          // Connection status updates
          if (state is SignalRConnected) {
          } else if (state is SignalRConnectionError) {
          } else if (state is ChatRoomJoined) {
          }
          
          // Cache messages when loaded
          if (state is ChatMessagesLoaded) {
            _cachedMessages = List.from(state.messages);
            
            // Schedule mark as read with delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.read<ChatBloc>().add(MarkChatRoomAsReadEvent(
                  chatRoomId: widget.chatRoomId,
                ));
              }
            });
          }
          
          // Add new sent message to cache
          if (state is MessageSent) {
            final isDuplicate = state.message.id.isNotEmpty &&
              _cachedMessages.any((msg) => msg.id == state.message.id);
                  if (!isDuplicate) {
                    setState(() {
                      _cachedMessages = [..._cachedMessages, state.message];
                    });
                    _scrollToBottom();
                  }
            }
          if (state is MessageReceived) {
            if (state.message.chatRoomId == widget.chatRoomId) {
        final isDuplicate = state.message.id.isNotEmpty &&
          _cachedMessages.any((msg) => msg.id == state.message.id);
              if (!isDuplicate) {
                setState(() {
                  _cachedMessages = [..._cachedMessages, state.message];
                });
                
                // Force immediate UI rebuild
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {});
                  }
                });
                
                _scrollToBottom(); // Auto scroll when new message received
              }
            }
          }
        },
        child: Column(
          children: [
            // SignalR Status Widget
            const SignalRStatusWidget(),
            
            // Test SignalR Connection Button (temporary)
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatBloc>().add(const ConnectSignalREvent());
                    },
                    child: const Text('Test SignalR'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatBloc>().add(JoinChatRoomEvent(
                        chatRoomId: widget.chatRoomId,
                      ));
                    },
                    child: const Text('Join Room'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final bloc = context.read<ChatBloc>();
                      try {
                        await bloc.signalRService.sendChatMessage(
                          chatRoomId: widget.chatRoomId,
                          message: 'direct-${DateTime.now().millisecondsSinceEpoch}',
                        );
                      } catch (e) {
                      }
                    },
                    child: const Text('Direct Send'),
                  ),
                ],
              ),
            ),
            
            // Messages List - PERSISTENT VERSION
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  
                  // Update cache if new messages loaded
                  if (state is ChatMessagesLoaded) {
                    _cachedMessages = List.from(state.messages);
                  }
                  
                  // Always show cached messages if available
                  if (_cachedMessages.isNotEmpty) {
                    
                    // Sort messages by sentAt time
                    final sortedMessages = List<ChatMessage>.from(_cachedMessages)
                      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
                    
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: sortedMessages.length,
                      itemBuilder: (context, index) {
                        final message = sortedMessages[index];
                        final isMyMessage = _isMyMessage(message);
                        
                        return Align(
                          alignment: isMyMessage 
                              ? Alignment.centerRight 
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: isMyMessage ? 50 : 8,
                              right: isMyMessage ? 8 : 50,
                              top: 4,
                              bottom: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMyMessage ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: isMyMessage 
                                  ? CrossAxisAlignment.end 
                                  : CrossAxisAlignment.start,
                              children: [
                                if (!isMyMessage) // Only show sender name for others' messages
                                  Text(
                                    message.senderName ?? "Unknown",
                                    style: const TextStyle(
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                if (!isMyMessage) const SizedBox(height: 4),
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isMyMessage ? Colors.white : Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${isMyMessage ? "You" : "Them"} | ${message.sentAt.toString().substring(11, 19)}',
                                  style: TextStyle(
                                    fontSize: 10, 
                                    color: isMyMessage ? Colors.white70 : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  
                  // Show loading state only if no cached messages
                  if (state is ChatMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is ChatMessagesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  
                  // Show this only if no cached messages and no specific loading state
                  return const Center(child: Text('Loading messages...'));
                },
              ),
            ),
            
            // Chat Input
            Container(
              padding: const EdgeInsets.all(8.0),
              child: ChatInputWidget(
                chatRoomId: widget.chatRoomId,
                onSend: (content) {
                  print('💬 ChatDetailPage - Sending message: "$content"');
                  print('🏠 To room: ${widget.chatRoomId}');
                  
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