import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:stream_cart_mobile/core/services/livekit_service.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';
import 'package:stream_cart_mobile/domain/repositories/chat_repository.dart';
import 'package:stream_cart_mobile/domain/entities/chat_entity.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final LivekitService livekitService;

  ChatBloc(this.chatRepository, this.livekitService) : super(ChatInitial()) {
    on<LoadChatRoom>(_onLoadChatRoom);
    on<LoadChatRooms>(_onLoadChatRooms);
    on<LoadChatRoomsByShop>(_onLoadChatRoomsByShop);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<MarkChatRoomAsRead>(_onMarkChatRoomAsRead);
    on<ConnectLiveKit>(_onConnectLiveKit);
    on<DisconnectLiveKit>(_onDisconnectLiveKit);
    on<ChatErrorEvent>(_onChatError);
  }

  Future<void> _onLoadChatRoom(LoadChatRoom event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final result = await chatRepository.getChatRoomMessages(event.chatRoomId);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (messages) => emit(ChatLoaded(messages: messages)), 
      );
    } catch (e) {
      emit(ChatError('Lỗi khi tải phòng chat: $e'));
    }
  }

  Future<void> _onLoadChatRooms(LoadChatRooms event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final result = await chatRepository.getChatRooms(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
        isActive: event.isActive,
      );
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
      );
    } catch (e) {
      emit(ChatError('Lỗi khi tải danh sách phòng: $e'));
    }
  }

  Future<void> _onLoadChatRoomsByShop(LoadChatRoomsByShop event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final result = await chatRepository.getChatRoomsByShop(
        event.shopId,
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
      );
    } catch (e) {
      emit(ChatError('Lỗi khi tải phòng theo shop: $e'));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final result = await chatRepository.sendMessage(
        chatRoomId: event.chatRoomId,
        content: event.message,
        messageType: event.messageType,
        attachmentUrl: event.attachmentUrl,
      );
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (message) => emit(ChatLoaded(messages: [message])),
      );
    } catch (e) {
      emit(ChatError('Lỗi khi gửi tin nhắn: $e'));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    final newMessage = ChatMessage(
      id: DateTime.now().toIso8601String(), 
      chatRoomId: '', 
      senderUserId: event.senderId,
      content: event.message,
      sentAt: DateTime.now(),
      isRead: false,
      isEdited: false,
      messageType: 'Text',
      senderName: '', 
      isMine: false, 
    );
    emit(ChatLoaded(messages: [newMessage]));
  }

  Future<void> _onMarkChatRoomAsRead(MarkChatRoomAsRead event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final result = await chatRepository.markChatRoomAsRead(event.chatRoomId);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) => emit(state), 
      );
    } catch (e) {
      emit(ChatError('Lỗi khi đánh dấu đã đọc: $e'));
    }
  }

  Future<void> _onConnectLiveKit(ConnectLiveKit event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      await livekitService.initializeRoom(
        chatRoomId: event.chatRoomId,
        userId: event.userId,
        userName: event.userName,
      );
      emit(LiveKitConnected(event.chatRoomId));
    } catch (e) {
      emit(ChatError('Lỗi khi kết nối LiveKit: $e'));
    }
  }

  Future<void> _onDisconnectLiveKit(DisconnectLiveKit event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      await livekitService.disconnect();
      emit(LiveKitDisconnected());
    } catch (e) {
      emit(ChatError('Lỗi khi ngắt kết nối LiveKit: $e'));
    }
  }

  void _onChatError(ChatErrorEvent event, Emitter<ChatState> emit) {
    emit(ChatError(event.message));
  }
}