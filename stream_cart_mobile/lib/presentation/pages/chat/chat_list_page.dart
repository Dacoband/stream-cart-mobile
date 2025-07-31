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
      final authState = context.read<AuthBloc>().state;
      int? roleValue;
      String? userId;
      String? userName;
      
      if (authState is AuthSuccess) {
        roleValue = authState.loginResponse.account.role;
        userId = authState.loginResponse.account.id;
        userName = authState.loginResponse.account.username;
      }
      final userRole = UserRole.fromValue(roleValue ?? 1);
      if (userRole == UserRole.seller) {
        context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
      } else {
        context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
      }
    });
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
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authState = context.read<AuthBloc>().state;
        int? roleValue;
        if (authState is AuthSuccess) {
          roleValue = authState.loginResponse.account.role;
        }
        final userRole = UserRole.fromValue(roleValue ?? 1);
        if (userRole == UserRole.seller) {
          context.read<ChatBloc>().add(LoadShopChatRooms(pageNumber: 1, pageSize: 20));
        } else {
          context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      message: 'Vui lòng đăng nhập để xem danh sách phòng chat',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách phòng chat'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomSearchBar(
                controller: TextEditingController(),
                hintText: 'Tìm kiếm phòng chat...',
                onChanged: (query) {
                  final authState = context.read<AuthBloc>().state;
                  int? roleValue;
                  if (authState is AuthSuccess) {
                    roleValue = authState.loginResponse.account.role;
                  }
                  final userRole = UserRole.fromValue(roleValue ?? 1);
                  if (userRole == UserRole.seller) {
                    context.read<ChatBloc>().add(LoadShopChatRooms(
                      pageNumber: 1,
                      pageSize: 20,
                      isActive: true,
                    ));
                  } else {
                    context.read<ChatBloc>().add(LoadChatRooms(
                      pageNumber: 1,
                      pageSize: 20,
                      isActive: true,
                    ));
                  }
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) return const CustomLoadingWidget();
            if (state is ChatError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<ChatBloc>().add(LoadChatRooms()),
              );
            }
            if (state is ChatRoomsLoaded) {
              return ChatListWidget(chatRooms: state.chatRooms);
            }
            return const Center(child: Text('Không có dữ liệu'));
          },
        ),
      ),
    );
  }
}