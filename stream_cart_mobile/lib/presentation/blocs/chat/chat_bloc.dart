import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/domain/entities/account_entity.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../core/models/user.dart';
import '../../../domain/entities/chat_entity.dart';
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
import '../auth/auth_bloc.dart';
import '../auth/auth_state.dart';

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
  String? _currentGlobalChatRoomId;
  bool _isGlobalConnectionActive = false;
  
  // Thêm biến cho reconnection
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _baseReconnectDelay = Duration(seconds: 2);

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
    on<ConnectGlobalLiveKit>(_onConnectGlobalLiveKit);
    on<DisconnectGlobalLiveKit>(_onDisconnectGlobalLiveKit);
    on<SwitchChatRoom>(_onSwitchChatRoom);

    // Setup listener cho LivekitService
    final livekitService = _tryGetLivekitService();
    if (livekitService != null) {
      livekitService.onStatusChanged = (status) {
        add(ChatLiveKitStatusChanged(status));
        
        // Handle specific disconnect reasons
        if (status.contains('DisconnectReason.joinFailure')) {
          print('🔴 Phát hiện joinFailure - sẽ được xử lý bởi LivekitService');
          // LivekitService sẽ tự động reconnect
        } else if (status.contains('Đã kết nối')) {
          _reconnectAttempts = 0;
          _reconnectTimer?.cancel();
          print('✅ Kết nối thành công - reset reconnect attempts');
        }
      };
    }
  }

  void _handleDisconnection() {
    // Chỉ handle khi LivekitService không tự reconnect được
    if (!_isGlobalConnectionActive || _currentGlobalChatRoomId == null) return;
    
    print('🔄 ChatBloc handling disconnection...');
    add(ChatErrorEvent('🔄 Đang kết nối lại...'));
    _startAutoReconnect();
  }

  // Giảm logic reconnect ở ChatBloc vì LivekitService đã handle
  void _startAutoReconnect() {
    if (_reconnectAttempts >= 2) { // Giảm xuống 2 attempts cho ChatBloc
      add(ChatErrorEvent('❌ LivekitService reconnect failed'));
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: 5 * _reconnectAttempts); // Tăng delay
    
    print('🔄 ChatBloc thử kết nối lại lần $_reconnectAttempts sau ${delay.inSeconds}s...');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_isGlobalConnectionActive && _currentGlobalChatRoomId != null) {
        _attemptReconnect();
      }
    });
  }

  void _attemptReconnect() async {
    try {
      // Sử dụng AuthBloc thay vì AuthService
      final authBloc = getIt<AuthBloc>();
      final authState = authBloc.state;
      
      if (authState is AuthSuccess && _currentGlobalChatRoomId != null) {
        final currentUser = authState.loginResponse.account;
        print('🔄 ChatBloc attempting reconnect to: $_currentGlobalChatRoomId');
        
        add(ConnectGlobalLiveKit(
          chatRoomId: _currentGlobalChatRoomId!,
          userId: currentUser.id,
          userName: currentUser.username,
        ));
      } else {
        print('❌ User not authenticated, cannot reconnect');
        add(ChatErrorEvent('User not authenticated'));
      }
    } catch (e) {
      print('❌ ChatBloc reconnect error: $e');
      _startAutoReconnect();
    }
  }

  Future<void> _onConnectGlobalLiveKit(ConnectGlobalLiveKit event, Emitter<ChatState> emit) async {
    print('🔗 _onConnectGlobalLiveKit called with chatRoomId: ${event.chatRoomId}');
    
    // Nếu đã kết nối cùng room, chỉ load messages
    if (_isGlobalConnectionActive && _currentGlobalChatRoomId == event.chatRoomId) {
      print('🔗 Already connected to same room, just loading messages...');
      add(LoadChatRoom(event.chatRoomId));
      return;
    }

    // Show appropriate loading state
    if (_reconnectAttempts == 0) {
      emit(ChatLoading());
    } else {
      emit(ChatReconnecting('🔄 Đang kết nối lại... (${_reconnectAttempts}/$_maxReconnectAttempts)'));
    }
    
    print('🔗 Attempting to connect to LiveKit for room: ${event.chatRoomId}');
    final result = await connectLiveKitUseCase(
      chatRoomId: event.chatRoomId,
      userId: event.userId,
      userName: event.userName,
    );
    
    result.fold(
      (failure) {
        print('❌ Connect failed: ${failure.message}');
        if (_reconnectAttempts > 0) {
          _startAutoReconnect();
        } else {
          emit(ChatError(failure.message));
        }
      },
      (_) {
        print('✅ Connected successfully to room: ${event.chatRoomId}');
        _currentGlobalChatRoomId = event.chatRoomId;
        _isGlobalConnectionActive = true;
        _reconnectAttempts = 0; 
        _reconnectTimer?.cancel();
        
        final livekitService = _tryGetLivekitService();
        livekitService?.setChatBloc(this);
        
        emit(LiveKitConnected(event.chatRoomId));
        
        // Đảm bảo load messages ngay sau khi connect
        print('🔗 Now loading messages for room: ${event.chatRoomId}');
        add(LoadChatRoom(event.chatRoomId));
      },
    );
  }

  Future<void> _onLoadChatRoom(LoadChatRoom event, Emitter<ChatState> emit) async {
    print('📥 _onLoadChatRoom called for chatRoomId: ${event.chatRoomId}');
    
    // Không emit ChatLoading nếu đang trong global connection flow
    if (!_isGlobalConnectionActive) {
      emit(ChatLoading());
    }
    
    final result = await loadChatRoomUseCase(event.chatRoomId);
    result.fold(
      (failure) {
        print('❌ Load messages failed: ${failure.message}');
        emit(ChatError(failure.message));
      },
      (messages) {
        print('✅ Loaded ${messages.length} messages for room: ${event.chatRoomId}');
        
        // Giữ chat rooms nếu có
        List<ChatEntity> currentChatRooms = [];
        if (state is ChatLoaded) {
          currentChatRooms = (state as ChatLoaded).chatRooms;
        } else if (state is ChatRoomsLoaded) {
          currentChatRooms = (state as ChatRoomsLoaded).chatRooms;
        }
        
        emit(ChatLoaded(
          messages: messages, 
          chatRoomId: event.chatRoomId,
          chatRooms: currentChatRooms,
          hasReachedMax: false,
        ));
      },
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

  // Helper method để lấy current user
  AccountEntity? _getCurrentUser() {
    try {
      final authBloc = getIt<AuthBloc>();
      final authState = authBloc.state;
      
      if (authState is AuthSuccess) {
        return authState.loginResponse.account;
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
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
      // FIX: Sử dụng helper method để lấy current user ID
      final currentUser = _getCurrentUser();
      final currentUserId = currentUser?.id;
      
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
          msg.content.trim() == newMessage.content.trim() && 
          msg.senderUserId == newMessage.senderUserId &&
          msg.sentAt.difference(newMessage.sentAt).abs().inSeconds < 10
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
          
          // Giữ chat rooms nếu có
          List<ChatEntity> currentChatRooms = [];
          if (state is ChatRoomsLoaded) {
            currentChatRooms = (state as ChatRoomsLoaded).chatRooms;
          }
          
          emit(ChatLoaded(
            messages: [newMessage],
            chatRoomId: event.chatRoomId,
            chatRooms: currentChatRooms,
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
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(ChatRoomsLoaded(chatRooms: currentState.chatRooms));
    }
  }

  void _onChatError(ChatErrorEvent event, Emitter<ChatState> emit) {
    emit(ChatError(event.message));
  }

  // Thêm method _tryGetLivekitService
  LivekitService? _tryGetLivekitService() {
    try {
      return getIt<LivekitService>();
    } catch (e) {
      print('❌ LivekitService not found: $e');
      return null;
    }
  }

  // Thêm method _onLiveKitStatusChanged
  void _onLiveKitStatusChanged(ChatLiveKitStatusChanged event, Emitter<ChatState> emit) {
    print('📡 LiveKit status changed: ${event.status}');
    
    emit(ChatStatusChanged(event.status));
    
    // FIX: Auto load messages khi reconnect thành công
    if (event.status.contains('✅') || event.status.contains('Đã kết nối')) {
      if (_currentGlobalChatRoomId != null) {
        print('🔄 Auto loading messages after reconnect...');
        add(LoadChatRoom(_currentGlobalChatRoomId!));
      }
    }
  }

  // Thêm method _onSwitchChatRoom
  Future<void> _onSwitchChatRoom(SwitchChatRoom event, Emitter<ChatState> emit) async {
    print('🔄 Switching to chat room: ${event.chatRoomId}');
    
    if (_isGlobalConnectionActive) {
      // Đã có kết nối global, chỉ load messages của room mới
      print('🔄 Already connected globally, just loading new room messages...');
      _currentGlobalChatRoomId = event.chatRoomId;
      add(LoadChatRoom(event.chatRoomId));
    } else {
      // Chưa có kết nối global, tạo mới
      print('🔄 No global connection, creating new connection...');
      add(ConnectGlobalLiveKit(
        chatRoomId: event.chatRoomId,
        userId: event.userId,
        userName: event.userName,
      ));
    }
  }

  // Thêm method _onDisconnectGlobalLiveKit
  Future<void> _onDisconnectGlobalLiveKit(DisconnectGlobalLiveKit event, Emitter<ChatState> emit) async {
    if (!_isGlobalConnectionActive) return;

    print('🔌 Disconnecting global LiveKit...');
    emit(ChatLoading());
    
    final result = await disconnectLiveKitUseCase();
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) {
        _isGlobalConnectionActive = false;
        _currentGlobalChatRoomId = null;
        _reconnectAttempts = 0;
        _reconnectTimer?.cancel();
        
        emit(LiveKitDisconnected());
        print('✅ Global LiveKit disconnected');
      },
    );
  }

  @override
  Future<void> close() async {
    _reconnectTimer?.cancel();
    if (_isGlobalConnectionActive) {
      try {
        await disconnectLiveKitUseCase();
      } catch (e) {
        print('Error disconnecting LiveKit on close: $e');
      }
    }
    return super.close();
  }
}