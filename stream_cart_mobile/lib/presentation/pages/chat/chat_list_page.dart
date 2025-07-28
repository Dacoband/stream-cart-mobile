import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/auth_guard.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/custom_search_bar.dart';
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
    // Gửi event load phòng chat khi vào trang
    context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
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
        context.read<ChatBloc>().add(LoadChatRooms(pageNumber: 1, pageSize: 20));
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
                hintText: 'Tìm phòng chat...',
                onChanged: (query) {
                  context.read<ChatBloc>().add(LoadChatRooms(
                    pageNumber: 1,
                    pageSize: 20,
                    isActive: true,
                  ));
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