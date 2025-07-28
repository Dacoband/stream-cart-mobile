import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/auth_guard.dart';
import 'package:stream_cart_mobile/presentation/widgets/common/custom_search_bar.dart';
import 'package:stream_cart_mobile/core/di/dependency_injection.dart';
import '../../../domain/usecases/chat/connect_livekit_usecase.dart';
import '../../../domain/usecases/chat/disconnect_livekit_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_usecase.dart';
import '../../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../../domain/usecases/chat/receive_message_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../widgets/chat/chat_list_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';




class ChatListPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return AuthGuard(
        message: 'Vui lòng đăng nhập để xem danh sách phòng chat',
        child: BlocProvider(
            create: (context) => ChatBloc(
            loadChatRoomUseCase: getIt<LoadChatRoomUseCase>(),
            loadChatRoomsByShopUseCase: getIt<LoadChatRoomsByShopUseCase>(),
            loadChatRoomsUseCase: getIt<LoadChatRoomsUseCase>(),
            sendMessageUseCase: getIt<SendMessageUseCase>(),
            receiveMessageUseCase: getIt<ReceiveMessageUseCase>(),
            markChatRoomAsReadUseCase: getIt<MarkChatRoomAsReadUseCase>(),
            connectLiveKitUseCase: getIt<ConnectLiveKitUseCase>(),
            disconnectLiveKitUseCase: getIt<DisconnectLiveKitUseCase>(),
            )..add(LoadChatRooms(pageNumber: 1, pageSize: 20)),
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
        ),
        );
    }
}