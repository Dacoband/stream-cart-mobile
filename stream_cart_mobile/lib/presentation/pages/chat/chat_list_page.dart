import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/auth_guard.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/custom_search_bar.dart';
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

    // Load chat rooms
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
        appBar: AppBar(
          title: const Text('Danh sách phòng chat'),
          actions: [
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatReconnecting) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                } else if (state is LiveKitConnected) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            print('🔍 ChatListPage body - Current state: ${state.runtimeType}');
            
            if (state is ChatLoading) {
              print('🔍 Showing loading...');
              return const CustomLoadingWidget();
            }
            
            if (state is ChatError) {
              print('🔍 Showing error: ${state.message}');
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
              return ChatListWidget(chatRooms: state.chatRooms);
            }
            
            if (state is ChatLoaded) {
              print('🔍 ChatLoaded detected - but this is LIST page');
              // QUAN TRỌNG: Ở ChatListPage, chỉ hiển thị chat rooms, KHÔNG hiển thị messages
              // Messages chỉ được hiển thị ở ChatDetailPage
              if (state.chatRooms.isNotEmpty) {
                print('🔍 Showing chat rooms from ChatLoaded: ${state.chatRooms.length}');
                return ChatListWidget(chatRooms: state.chatRooms);
              } else {
                // Nếu không có chat rooms, load lại
                print('🔍 No chat rooms in ChatLoaded, loading chat rooms...');
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
              print('🔍 LiveKit connected, but need to load chat rooms');
              // Khi LiveKit connected, load chat rooms
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
            
            print('🔍 Unknown state, showing no data message');
            return const Center(child: Text('Không có dữ liệu'));
          },
        ),
      ),
    );
  }
}