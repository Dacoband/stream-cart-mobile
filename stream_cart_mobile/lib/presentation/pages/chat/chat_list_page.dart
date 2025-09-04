import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/auth_guard.dart';
import '../../../core/enums/user_role.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/chat/chat_list_widget.dart';
import '../../widgets/chat/signalr_status_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForAuthAndInitialize();
    });
  }

  Future<void> _waitForAuthAndInitialize() async {
    // Đợi một chút để auth state được load
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      final authState = context.read<AuthBloc>().state;
      
      if (authState is AuthSuccess) {
        _initializeChatAndConnection();
      } else {
        // Nếu vẫn chưa auth success thì đợi thêm
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          _initializeChatAndConnection();
        }
      }
    }
  }

  void _initializeChatAndConnection() {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! AuthSuccess) {
      return;
    }

    final roleValue = authState.loginResponse.account.role;
    final userRole = UserRole.fromValue(roleValue);
    
    // Connect SignalR first
    context.read<ChatBloc>().add(const ConnectSignalREvent());
    
    // Load chat rooms based on role
    if (userRole == UserRole.customer) {
      context.read<ChatBloc>().add(const LoadChatRoomsEvent(
        pageNumber: 1, 
        pageSize: 20,
        isRefresh: true,
      ));
    } else if (userRole == UserRole.seller) {
      context.read<ChatBloc>().add(const LoadShopChatRoomsEvent(
        pageNumber: 1, 
        pageSize: 20,
        isRefresh: true,
      ));
    }

    // Load unread count
    context.read<ChatBloc>().add(const LoadUnreadCountEvent());
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshChatRooms();
      }
    });
  }

  void _refreshChatRooms() {
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! AuthSuccess) {
      return;
    }

    final roleValue = authState.loginResponse.account.role;
    final userRole = UserRole.fromValue(roleValue);
    
    // Dispatch appropriate event based on role
    if (userRole == UserRole.customer) {
      context.read<ChatBloc>().add(const LoadChatRoomsEvent(
        pageNumber: 1, 
        pageSize: 20,
        isRefresh: true,
      ));
    } else if (userRole == UserRole.seller) {
      context.read<ChatBloc>().add(const LoadShopChatRoomsEvent(
        pageNumber: 1, 
        pageSize: 20,
        isRefresh: true,
      ));
    }

    // Reload unread count
    context.read<ChatBloc>().add(const LoadUnreadCountEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      message: 'Vui lòng đăng nhập để xem danh sách phòng chat',
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF202328),
          elevation: 0,
          title: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              int unreadCount = 0;
              if (state is UnreadCountLoaded) {
                unreadCount = state.unreadCount.totalUnreadCount;
              } else if (state is ChatRoomsLoaded) {
                unreadCount = state.chatRooms
                    .where((room) => room.hasUnreadMessages)
                    .fold(0, (sum, room) => sum + room.unreadCount);
              } else if (state is ShopChatRoomsLoaded) {
                unreadCount = state.chatRooms
                    .where((room) => room.hasUnreadMessages)
                    .fold(0, (sum, room) => sum + room.unreadCount);
              }

              return Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFFB0F847),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Tin nhắn',
                      style: TextStyle(
                        color: Color(0xFFB0F847),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is SignalRConnecting) {
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
                } else if (state is SignalRConnected) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
                  );
                } else if (state is SignalRConnectionError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tooltip(
                      message: 'Connection Error',
                      child: const Icon(Icons.circle, color: Colors.red, size: 12),
                    ),
                  );
                } else if (state is SignalRDisconnected) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, color: Colors.orange, size: 12),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFFB0F847)),
                  onPressed: () => _refreshChatRooms(),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // SignalR Status Widget
            const SignalRStatusWidget(),
            
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm cuộc trò chuyện...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onChanged: (value) {
                  // TODO: Implement search functionality
                  // For now, this is just UI
                },
              ),
            ),
            
            // Chat Rooms List
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatRoomsLoading) {
                    return const CustomLoadingWidget();
                  }
                  
                  if (state is ChatError || state is ChatRoomsError) {
                    final message = state is ChatError 
                        ? state.message 
                        : (state as ChatRoomsError).message;
                    return CustomErrorWidget(
                      message: message,
                      onRetry: () => _refreshChatRooms(),
                    );
                  }
                  
                  if (state is ChatRoomsLoaded) {
                    if (state.chatRooms.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có cuộc trò chuyện nào',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Hãy bắt đầu mua sắm để chat với shop!',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    return ChatListWidget(chatRooms: state.chatRooms);
                  }
                  
                  if (state is ShopChatRoomsLoaded) {
                    if (state.chatRooms.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.store, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có khách hàng nào nhắn tin',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Khách hàng sẽ chat khi quan tâm đến sản phẩm',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    return ChatListWidget(chatRooms: state.chatRooms);
                  }
                  
                  if (state is SignalRConnected) {
                    // Auto-load chat rooms when SignalR connects
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _refreshChatRooms();
                      }
                    });
                    return const CustomLoadingWidget();
                  }
                  
                  if (state is SignalRDisconnected) {
                    // Auto-reconnect when disconnected
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            context.read<ChatBloc>().add(const ConnectSignalREvent());
                          }
                        });
                      }
                    });
                  }
                  
                  return const Center(
                    child: Text(
                      'Kéo xuống để tải danh sách chat',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthSuccess) {
              final roleValue = authState.loginResponse.account.role;
              final userRole = UserRole.fromValue(roleValue);
              
              // Only show FAB for customers
              if (userRole == UserRole.customer) {
                return FloatingActionButton(
                  onPressed: () {
                    // Navigate to shop list to start new chat
                    Navigator.pushNamed(context, '/shops');
                  },
                  backgroundColor: const Color(0xFFB0F847),
                  child: const Icon(Icons.add_comment, color: Colors.black),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}