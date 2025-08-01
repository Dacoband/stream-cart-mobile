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
      _initializeChatAndConnection();
    });
  }

  void _initializeChatAndConnection() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthSuccess) return;

    final roleValue = authState.loginResponse.account.role;
    final userRole = UserRole.fromValue(roleValue ?? 1);

    print('🚀 Initializing chat for role: $userRole');
    if (userRole == UserRole.seller) {
      context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
    } else {
      context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
    }
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
    if (authState is! AuthSuccess) return;

    final roleValue = authState.loginResponse.account.role;
    final userRole = UserRole.fromValue(roleValue ?? 1);

    if (userRole == UserRole.seller) {
      context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
    } else {
      context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
    }
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
              return Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFFB0F847),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tin nhắn',
                      style: const TextStyle(
                        color: Color(0xFFB0F847),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (state is ChatRoomsLoaded && state.totalUnreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${state.totalUnreadCount}',
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
                if (state is ChatReconnecting) {
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
                } else if (state is LiveKitConnected) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
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
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const CustomLoadingWidget();
            }
            
            if (state is ChatError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthSuccess) {
                    final roleValue = authState.loginResponse.account.role;
                    final userRole = UserRole.fromValue(roleValue ?? 1);
                    
                    if (userRole == UserRole.seller) {
                      context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
                    } else {
                      context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
                    }
                  }
                },
              );
            }
            
            if (state is ChatRoomsLoaded) {
              print('🔍 Showing chat rooms: ${state.chatRooms.length}');
              if (state.chatRooms.isEmpty) {
                return const Center(child: Text('Không có phòng chat nào'));
              }
              return IconTheme(
                data: const IconThemeData(color: Color(0xFFB0F847)),
                child: ChatListWidget(chatRooms: state.chatRooms),
              );
            }
            
            if (state is ChatLoaded) {
              if (state.chatRooms.isNotEmpty) {
                return IconTheme(
                  data: const IconThemeData(color: Color(0xFFB0F847)),
                  child: ChatListWidget(chatRooms: state.chatRooms),
                );
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthSuccess) {
                    final roleValue = authState.loginResponse.account.role;
                    final userRole = UserRole.fromValue(roleValue ?? 1);
                    
                    if (userRole == UserRole.seller) {
                      context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
                    } else {
                      context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
                    }
                  }
                });
                return const CustomLoadingWidget();
              }
            }
            
            if (state is LiveKitConnected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthSuccess) {
                  final roleValue = authState.loginResponse.account.role;
                  final userRole = UserRole.fromValue(roleValue ?? 1);
                  
                  if (userRole == UserRole.seller) {
                    context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
                  } else {
                    context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
                  }
                }
              });
              return const CustomLoadingWidget();
            }
            return const Center(child: Text('Không có dữ liệu'));
          },
        ),
      ),
    );
  }
}