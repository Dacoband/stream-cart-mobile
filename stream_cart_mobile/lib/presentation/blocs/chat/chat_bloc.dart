import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../domain/usecases/chat/connect_livekit_usecase.dart';
import '../../../domain/usecases/chat/disconnect_livekit_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_usecase.dart';
import '../../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../../domain/usecases/chat/receive_message_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../core/services/livekit_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final LoadChatRoomUseCase loadChatRoomUseCase;
  final LoadChatRoomsUseCase loadChatRoomsUseCase;
  final LoadChatRoomsByShopUseCase loadChatRoomsByShopUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final ReceiveMessageUseCase receiveMessageUseCase;
  final MarkChatRoomAsReadUseCase markChatRoomAsReadUseCase;
  final ConnectLiveKitUseCase connectLiveKitUseCase;
  final DisconnectLiveKitUseCase disconnectLiveKitUseCase;

  ChatBloc({
    required this.loadChatRoomUseCase,
    required this.loadChatRoomsUseCase,
    required this.loadChatRoomsByShopUseCase,
    required this.sendMessageUseCase,
    required this.receiveMessageUseCase,
    required this.markChatRoomAsReadUseCase,
    required this.connectLiveKitUseCase,
    required this.disconnectLiveKitUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatRoom>(_onLoadChatRoom);
    on<LoadChatRooms>(_onLoadChatRooms);
    on<LoadChatRoomsByShop>(_onLoadChatRoomsByShop);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<MarkChatRoomAsRead>(_onMarkChatRoomAsRead);
    on<ConnectLiveKit>(_onConnectLiveKit);
    on<DisconnectLiveKit>(_onDisconnectLiveKit);
    on<ChatErrorEvent>(_onChatError);
    on<ChatLiveKitStatusChanged>(_onLiveKitStatusChanged);

    // Listen to LivekitService status if available
    final livekitService = _tryGetLivekitService();
    if (livekitService != null) {
      livekitService.onStatusChanged = (status) {
        add(ChatLiveKitStatusChanged(status));
      };
    }
  }

  LivekitService? _tryGetLivekitService() {
    try {
      // Nếu dùng getIt hoặc DI, lấy LivekitService ở đây
      // import '../services/livekit_service.dart';
      // return getIt<LivekitService>();
      return null; // Nếu không dùng getIt thì bỏ qua
    } catch (_) {
      return null;
    }
  }

  void _onLiveKitStatusChanged(ChatLiveKitStatusChanged event, Emitter<ChatState> emit) {
    final status = event.status;
    if (status.contains('Đang kết nối lại')) {
      emit(ChatReconnecting(status));
    } else if (status.contains('Reconnect thất bại') || status.contains('Kết nối thất bại')) {
      emit(ChatReconnectFailed(status));
    } else if (status.contains('Đã kết nối')) {
      // Có thể emit LiveKitConnected nếu muốn
      emit(ChatStatusChanged(status));
    } else if (status.contains('Lỗi kết nối')) {
      emit(ChatError(status));
    } else {
      emit(ChatStatusChanged(status));
    }
  }

  Future<void> _onLoadChatRoom(LoadChatRoom event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await loadChatRoomUseCase(event.chatRoomId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatLoaded(messages: messages)),
    );
  }

  Future<void> _onLoadChatRooms(LoadChatRooms event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await loadChatRoomsUseCase(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      isActive: event.isActive,
    );
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
    );
  }

  Future<void> _onLoadChatRoomsByShop(LoadChatRoomsByShop event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await loadChatRoomsByShopUseCase(
      shopId: event.shopId,
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
    );
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
    );
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await sendMessageUseCase(
      chatRoomId: event.chatRoomId,
      content: event.message,
      messageType: event.messageType,
      attachmentUrl: event.attachmentUrl,
    );
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) => emit(ChatLoaded(messages: [message])),
    );
  }

  Future<void> _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) async {
    final result = await receiveMessageUseCase(
      message: event.message,
      senderId: event.senderId,
      chatRoomId: event.chatRoomId,
      senderName: event.senderName,
      isMine: event.isMine,
    );
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (newMessage) {
        if (state is ChatLoaded) {
          final currentState = state as ChatLoaded;
          emit(currentState.copyWith(
            messages: [...currentState.messages, newMessage],
            chatRoomId: event.chatRoomId, 
          ));
        } else {
          emit(ChatLoaded(
            messages: [newMessage],
            chatRoomId: event.chatRoomId,
            chatRooms: const [], 
            hasReachedMax: false,
          ));
        }
      },
    );
  }

  Future<void> _onMarkChatRoomAsRead(MarkChatRoomAsRead event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await markChatRoomAsReadUseCase(event.chatRoomId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(state),
    );
  }

  Future<void> _onConnectLiveKit(ConnectLiveKit event, Emitter<ChatState> emit) async {
  emit(ChatLoading());
  final result = await connectLiveKitUseCase(
    chatRoomId: event.chatRoomId,
    userId: event.userId,
    userName: event.userName,
  );
  result.fold(
    (failure) => emit(ChatError(failure.message)),
    (_) {
      emit(LiveKitConnected(event.chatRoomId));
      add(LoadChatRoom(event.chatRoomId));
    },
  );
}

  Future<void> _onDisconnectLiveKit(DisconnectLiveKit event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await disconnectLiveKitUseCase();
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(LiveKitDisconnected()),
    );
  }

  void _onChatError(ChatErrorEvent event, Emitter<ChatState> emit) {
    emit(ChatError(event.message));
  }
}