import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../domain/usecases/chat/connect_livekit_usecase.dart';
import '../../../domain/usecases/chat/disconnect_livekit_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_usecase.dart';
import '../../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/load_shop_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../../domain/usecases/chat/receive_message_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../core/services/livekit_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/di/dependency_injection.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final LoadChatRoomUseCase loadChatRoomUseCase;
  final LoadChatRoomsUseCase loadChatRoomsUseCase;
  final LoadChatRoomsByShopUseCase loadChatRoomsByShopUseCase;
  final LoadShopChatRoomsUseCase loadShopChatRoomsUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final ReceiveMessageUseCase receiveMessageUseCase;
  final MarkChatRoomAsReadUseCase markChatRoomAsReadUseCase;
  final ConnectLiveKitUseCase connectLiveKitUseCase;
  final DisconnectLiveKitUseCase disconnectLiveKitUseCase;

  ChatBloc({
    required this.loadChatRoomUseCase,
    required this.loadChatRoomsUseCase,
    required this.loadChatRoomsByShopUseCase,
    required this.loadShopChatRoomsUseCase,
    required this.sendMessageUseCase,
    required this.receiveMessageUseCase,
    required this.markChatRoomAsReadUseCase,
    required this.connectLiveKitUseCase,
    required this.disconnectLiveKitUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatRoom>(_onLoadChatRoom);
    on<LoadChatRooms>(_onLoadChatRooms);
    on<LoadChatRoomsByShop>(_onLoadChatRoomsByShop);
    on<LoadShopChatRooms>(_onLoadShopChatRooms);
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
      // Sử dụng getIt để lấy LivekitService
      return getIt<LivekitService>();
    } catch (e) {
      print('⚠️ Không thể lấy LivekitService: $e');
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
      (messages) => emit(ChatLoaded(
        messages: messages, 
        chatRoomId: event.chatRoomId,
      )),
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

  Future<void> _onLoadShopChatRooms(LoadShopChatRooms event, Emitter<ChatState> emit) async {
  emit(ChatLoading());
  final result = await loadShopChatRoomsUseCase(
    pageNumber: event.pageNumber,
    pageSize: event.pageSize,
    isActive: event.isActive,
  );
  result.fold(
    (failure) => emit(ChatError(failure.message)),
    (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
  );
}

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    
    // 1. Gửi tin nhắn qua API để lưu vào database
    final result = await sendMessageUseCase(
      chatRoomId: event.chatRoomId,
      content: event.message,
      messageType: event.messageType,
      attachmentUrl: event.attachmentUrl,
    );
    
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) {
        // 2. Gửi tin nhắn qua LiveKit để real-time
        final livekitService = _tryGetLivekitService();
        if (livekitService?.isConnected == true) {
          final livekitMessage = {
            'content': message.content,
            'senderUserId': message.senderUserId,
            'senderName': message.senderName,
            'sentAt': DateTime.now().toIso8601String(),
            'messageType': message.messageType,
            'isMine': true,
          };
          
          final jsonString = jsonEncode(livekitMessage);
          livekitService?.sendDataMessage(jsonString);
          print('✅ Đã gửi tin nhắn qua LiveKit JSON: ${message.content}');
        } else {
          print('⚠️ LiveKit không kết nối, chỉ gửi qua API');
        }
        
        // 3. Thêm tin nhắn vào UI ngay lập tức
        print('🔄 Đang thêm tin nhắn vào UI: ${message.content}');
        add(ReceiveMessage(
          message.content,
          message.senderUserId,
          message.chatRoomId,
          message.senderName,
          true, 
        ));
        print('✅ Đã dispatch ReceiveMessage event');
      },
    );
  }

  Future<void> _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) async {
    print('📨 _onReceiveMessage được gọi với: ${event.message}');
    print('📨 Current state: ${state.runtimeType}');
    
    String content = event.message;
    String senderUserId = event.senderId;
    String senderName = event.senderName;
    bool isMine = event.isMine;
    bool isFromLiveKit = false;
    
    // Kiểm tra xem có phải JSON format từ LiveKit không
    try {
      final parsed = jsonDecode(event.message);
      if (parsed is Map<String, dynamic> && parsed.containsKey('content')) {
        isFromLiveKit = true;
        content = parsed['content'] ?? '';
        senderUserId = parsed['senderUserId'] ?? event.senderId;
        senderName = parsed['senderName'] ?? event.senderName;
        
        print('📨 Nhận tin nhắn LiveKit JSON từ $senderName: $content');
      }
    } catch (e) {
      if (event.message.contains('|')) {
        isFromLiveKit = true;
        List<String> parts = event.message.split('|');
        if (parts.length >= 5) {
          content = parts[0];
          senderUserId = parts[1];
          senderName = parts[2];
          
          print('📨 Nhận tin nhắn LiveKit legacy từ $senderName: $content');
        }
      }
    }
    if (isFromLiveKit) {
      final authService = getIt<AuthService>();
      final currentUserId = await authService.getCurrentUserId();
      isMine = currentUserId != null && currentUserId == senderUserId;
      print('📨 LiveKit - Current userId: $currentUserId, senderUserId: $senderUserId, isMine: $isMine');
    } else {
      print('📨 Local dispatch - keeping original isMine: $isMine');
    }
    
    final result = await receiveMessageUseCase(
      message: content,
      senderId: senderUserId,
      chatRoomId: event.chatRoomId,
      senderName: senderName,
      isMine: isMine,
    );
    
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (newMessage) {
        print('📝 Tin nhắn mới được tạo: ${newMessage.content}');
        if (state is ChatLoaded) {
          final currentState = state as ChatLoaded;
          print('📋 Current messages count: ${currentState.messages.length}');
          final isDuplicate = currentState.messages.any((msg) => 
            msg.content == newMessage.content && 
            msg.senderUserId == newMessage.senderUserId &&
            msg.sentAt.difference(newMessage.sentAt).abs().inSeconds < 5
          );
          
          print('🔍 Is duplicate: $isDuplicate');
          
          if (!isDuplicate) {
            final updatedMessages = [...currentState.messages, newMessage];
            print('📬 Updating messages count: ${currentState.messages.length} -> ${updatedMessages.length}');
            emit(currentState.copyWith(
              messages: updatedMessages, 
              chatRoomId: event.chatRoomId,
            ));
            print('✅ Đã thêm tin nhắn vào UI: $content');
          } else {
            print('⚠️ Bỏ qua tin nhắn duplicate: $content');
          }
        } else {
          print('📋 State không phải ChatLoaded, tạo mới với 1 tin nhắn');
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
        final livekitService = _tryGetLivekitService();
        livekitService?.setChatBloc(this);
        
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