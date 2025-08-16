import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:stream_cart_mobile/domain/entities/account/account_entity.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_event.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_state.dart';

import '../../../core/enums/user_role.dart';
import '../../../domain/usecases/chat/load_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_detail_usecase.dart';
import '../../../domain/usecases/chat/load_chat_room_messages_usecase.dart';
import '../../../domain/usecases/chat/search_chat_room_messages_usecase.dart';
import '../../../domain/usecases/chat/create_chat_room_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../domain/usecases/chat/update_message_usecase.dart';
import '../../../domain/usecases/chat/receive_message_usecase.dart';
import '../../../domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import '../../../domain/usecases/chat/send_typing_indicator_usecase.dart';
import '../../../domain/usecases/chat/connect_signalr_usecase.dart';
import '../../../domain/usecases/chat/disconnect_signalr_usecase.dart';
import '../../../domain/usecases/chat/join_chat_room_usecase.dart';
import '../../../domain/usecases/chat/leave_chat_room_usecase.dart';
import '../../../domain/usecases/chat/load_shop_chat_rooms_usecase.dart';
import '../../../domain/usecases/chat/get_unread_count_usecase.dart';
import '../../../core/services/signalr_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // UseCases
  final LoadChatRoomsUseCase loadChatRoomsUseCase;
  final LoadChatRoomDetailUseCase loadChatRoomDetailUseCase;
  final LoadChatRoomMessagesUseCase loadChatRoomMessagesUseCase;
  final SearchChatRoomMessagesUseCase searchChatRoomMessagesUseCase;
  final CreateChatRoomUseCase createChatRoomUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  final ReceiveMessageUseCase receiveMessageUseCase;
  final MarkChatRoomAsReadUseCase markChatRoomAsReadUseCase;
  final SendTypingIndicatorUseCase sendTypingIndicatorUseCase;
  final ConnectSignalRUseCase connectSignalRUseCase;
  final DisconnectSignalRUseCase disconnectSignalRUseCase;
  final JoinChatRoomUseCase joinChatRoomUseCase;
  final LeaveChatRoomUseCase leaveChatRoomUseCase;
  final LoadShopChatRoomsUseCase loadShopChatRoomsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;

  // SignalR Service
  final SignalRService signalRService;

  // State tracking
  String? _currentChatRoomId;
  bool _isSignalRConnected = false;
  String? _pendingJoinChatRoomId;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;
  Timer? _typingTimer;
  final Set<String> _typingUsers = {};

  ChatBloc({
    required this.loadChatRoomsUseCase,
    required this.loadChatRoomDetailUseCase,
    required this.loadChatRoomMessagesUseCase,
    required this.searchChatRoomMessagesUseCase,
    required this.createChatRoomUseCase,
    required this.sendMessageUseCase,
    required this.updateMessageUseCase,
    required this.receiveMessageUseCase,
    required this.markChatRoomAsReadUseCase,
    required this.sendTypingIndicatorUseCase,
    required this.connectSignalRUseCase,
    required this.disconnectSignalRUseCase,
    required this.joinChatRoomUseCase,
    required this.leaveChatRoomUseCase,
    required this.loadShopChatRoomsUseCase,
    required this.getUnreadCountUseCase,
    required this.signalRService,
  }) : super(ChatInitial()) {
    // Register event handlers
    on<LoadChatRoomsEvent>(_onLoadChatRooms);
    on<LoadChatRoomDetailEvent>(_onLoadChatRoomDetail);
    on<LoadChatRoomMessagesEvent>(_onLoadChatRoomMessages);
    on<SearchChatRoomMessagesEvent>(_onSearchChatRoomMessages);
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<SendMessageEvent>(_onSendMessage);
    on<UpdateMessageEvent>(_onUpdateMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
    on<MarkChatRoomAsReadEvent>(_onMarkChatRoomAsRead);
    on<SendTypingIndicatorEvent>(_onSendTypingIndicator);
    on<UserTypingChangedEvent>(_onUserTypingChanged);
    on<ConnectSignalREvent>(_onConnectSignalR);
    on<DisconnectSignalREvent>(_onDisconnectSignalR);
    on<SignalRConnectionChangedEvent>(_onSignalRConnectionChanged);
    on<JoinChatRoomEvent>(_onJoinChatRoom);
    on<LeaveChatRoomEvent>(_onLeaveChatRoom);
    on<LoadShopChatRoomsEvent>(_onLoadShopChatRooms);
    on<LoadUnreadCountEvent>(_onLoadUnreadCount);
    on<UpdateUnreadCountEvent>(_onUpdateUnreadCount);
    on<UserJoinedRoomEvent>(_onUserJoinedRoom);
    on<UserLeftRoomEvent>(_onUserLeftRoom);
    on<ChatErrorEvent>(_onChatError);
    on<ClearChatStateEvent>(_onClearChatState);
    on<ClearMessagesEvent>(_onClearMessages);
    on<ClearSearchResultsEvent>(_onClearSearchResults);
    on<TypingReceivedEvent>(_onTypingReceived);

    // Setup SignalR listeners
    _setupSignalRListeners();
  }

  void _setupSignalRListeners() {
    // Updated callback signatures according to refactored SignalRService
    signalRService.onUserTyping = (userId, isTyping) {
      add(TypingReceivedEvent(
        userId: userId,
        chatRoomId: _currentChatRoomId ?? '',
        userName: 'Unknown User',
        isTyping: isTyping,
        timestamp: DateTime.now(),
      ));
    };

    signalRService.onReceiveChatMessage = (messageData) {
      add(ReceiveMessageEvent(messageData: messageData));
    };
  // Legacy callback compatibility if service were to expose onReceiveMessage again
  // (No-op if not provided)

    signalRService.onUserJoinedRoom = (userId, userName) {
      add(UserJoinedRoomEvent(
        userId: userId,
        chatRoomId: _currentChatRoomId ?? '',
        userName: userName,
      ));
    };

    signalRService.onUserLeftRoom = (userId, userName) {
      add(UserLeftRoomEvent(
        userId: userId,
        chatRoomId: _currentChatRoomId ?? '',
        userName: userName,
      ));
    };

    signalRService.onStatusChanged = (status) {
      // Handle status changes if needed
    };

    signalRService.onConnectionStateChanged = (state) {
      if (state == HubConnectionState.connected) {
        final target = _currentChatRoomId ?? _pendingJoinChatRoomId;
        if (target != null) {
          add(JoinChatRoomEvent(chatRoomId: target));
        }
      }
    };
  }

  // Chat Rooms - Updated để check role Customer vs Seller
  Future<void> _onLoadChatRooms(LoadChatRoomsEvent event, Emitter<ChatState> emit) async {
    if (event.isRefresh) {
      emit(ChatLoading());
    } else {
      emit(ChatRoomsLoading());
    }

    final result = await loadChatRoomsUseCase(LoadChatRoomsParams(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      isActive: event.isActive,
    ));

    result.fold(
      (failure) {
        emit(ChatRoomsError(message: failure.message));
      },
      (paginatedResponse) {
        emit(ChatRoomsLoaded(
          chatRooms: paginatedResponse.items,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages,
          hasNext: paginatedResponse.hasNext,
          hasPrevious: paginatedResponse.hasPrevious,
          totalCount: paginatedResponse.totalCount,
          isRefresh: event.isRefresh,
        ));
      },
    );
  }

  Future<void> _onLoadChatRoomDetail(LoadChatRoomDetailEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    
    final result = await loadChatRoomDetailUseCase(LoadChatRoomDetailParams(
      chatRoomId: event.chatRoomId,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (chatRoom) => emit(ChatRoomDetailLoaded(chatRoom: chatRoom)),
    );
  }

  // Messages
  Future<void> _onLoadChatRoomMessages(LoadChatRoomMessagesEvent event, Emitter<ChatState> emit) async {
    if (event.isRefresh) {
      emit(ChatLoading());
    } else {
      emit(ChatMessagesLoading());
    }

    final result = await loadChatRoomMessagesUseCase(LoadChatRoomMessagesParams(
      chatRoomId: event.chatRoomId,
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
    ));

    result.fold(
      (failure) {
        emit(ChatMessagesError(
          message: failure.message,
          chatRoomId: event.chatRoomId,
        ));
      },
      (messages) {
        emit(ChatMessagesLoaded(
          messages: messages,
          chatRoomId: event.chatRoomId,
          currentPage: event.pageNumber,
          hasMoreMessages: messages.length == event.pageSize,
        ));
      },
    );
  }

  Future<void> _onSearchChatRoomMessages(SearchChatRoomMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    
    final result = await searchChatRoomMessagesUseCase(SearchChatRoomMessagesParams(
      chatRoomId: event.chatRoomId,
      searchTerm: event.searchTerm,
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (messages) => emit(MessageSearchLoaded(
        searchResults: messages,
        searchTerm: event.searchTerm,
        chatRoomId: event.chatRoomId,
        currentPage: event.pageNumber,
        hasMoreResults: messages.length == event.pageSize,
      )),
    );
  }

  // Update create chat room để chỉ Customer mới tạo được
  Future<void> _onCreateChatRoom(CreateChatRoomEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    
    // Chỉ Customer mới có thể tạo chat room mới với Seller
    if (!_isCustomerUser()) {
      emit(const ChatError(message: 'Only customers can create new chat rooms with sellers'));
      return;
    }

    final result = await createChatRoomUseCase(CreateChatRoomParams(
      shopId: event.shopId,
      relatedOrderId: event.relatedOrderId,
      initialMessage: event.initialMessage,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (chatRoom) => emit(ChatRoomCreated(chatRoom: chatRoom)),
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    emit(MessageSending(tempMessageId: tempMessageId, content: event.content));

    // Send via HTTP API first
    final result = await sendMessageUseCase(SendMessageParams(
      chatRoomId: event.chatRoomId,
      content: event.content,
      messageType: event.messageType,
      attachmentUrl: event.attachmentUrl,
    ));

    result.fold(
      (failure) {
        emit(MessageSendError(
          message: failure.message,
          tempMessageId: tempMessageId,
        ));
      },
      (message) async {
        emit(MessageSent(message: message));
        if (_isSignalRConnected) {
          try {
            if (_currentChatRoomId != event.chatRoomId) {
              final joinResult = await joinChatRoomUseCase(JoinChatRoomParams(chatRoomId: event.chatRoomId));
              joinResult.fold(
                (l) => null,
                (r) {
                  _currentChatRoomId = event.chatRoomId;
                },
              );
            }
            await signalRService.sendChatMessage(
              chatRoomId: event.chatRoomId,
              message: event.content,
            );
          } catch (e) {
            // ignore: avoid_print
            print('[ChatBloc] Realtime send failed: $e');
          }
        } else {
          add(JoinChatRoomEvent(chatRoomId: event.chatRoomId));
          add(const ConnectSignalREvent());
        }
      },
    );
  }

  Future<void> _onUpdateMessage(UpdateMessageEvent event, Emitter<ChatState> emit) async {
    final result = await updateMessageUseCase(UpdateMessageParams(
      messageId: event.messageId,
      content: event.content,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (message) => emit(MessageUpdated(message: message)),
    );
  }

  Future<void> _onReceiveMessage(ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    final prevState = state;
    final result = await receiveMessageUseCase(ReceiveMessageParams(
      messageData: event.messageData,
    ));

    result.fold(
      (failure) {
        emit(ChatError(message: failure.message));
      },
      (parsedMessage) {
        var message = parsedMessage;
        if ((message.chatRoomId).isEmpty && _currentChatRoomId != null) {
          message = message.copyWith(chatRoomId: _currentChatRoomId);
        }
        emit(MessageReceived(message: message));
        if (prevState is ChatMessagesLoaded && prevState.chatRoomId == message.chatRoomId) {
          final exists = prevState.messages.any((m) => m.id.isNotEmpty && m.id == message.id);
          final updatedMessages = exists ? prevState.messages : [...prevState.messages, message];
          emit(prevState.copyWith(messages: updatedMessages));
        }
      },
    );
  }

  Future<void> _onMarkChatRoomAsRead(MarkChatRoomAsReadEvent event, Emitter<ChatState> emit) async {
    final result = await markChatRoomAsReadUseCase(MarkChatRoomAsReadParams(
      chatRoomId: event.chatRoomId,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) => emit(ChatRoomMarkedAsRead(chatRoomId: event.chatRoomId)),
    );
  }

  // Typing Indicator
  Future<void> _onSendTypingIndicator(SendTypingIndicatorEvent event, Emitter<ChatState> emit) async {
    final result = await sendTypingIndicatorUseCase(SendTypingIndicatorParams(
      chatRoomId: event.chatRoomId,
      isTyping: event.isTyping,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) => emit(TypingIndicatorSent(
        chatRoomId: event.chatRoomId,
        isTyping: event.isTyping,
      )),
    );
  }

  void _onUserTypingChanged(UserTypingChangedEvent event, Emitter<ChatState> emit) {
    if (event.isTyping) {
      _typingUsers.add(event.userId);
    } else {
      _typingUsers.remove(event.userId);
    }

    emit(UserTypingChanged(
      userId: event.userId,
      chatRoomId: event.chatRoomId,
      isTyping: event.isTyping,
    ));

    // Auto-remove typing indicator after timeout
    if (event.isTyping) {
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _typingUsers.remove(event.userId);
        add(UserTypingChangedEvent(
          userId: event.userId,
          chatRoomId: event.chatRoomId,
          isTyping: false,
        ));
      });
    }
  }

  // SignalR Connection
  Future<void> _onConnectSignalR(ConnectSignalREvent event, Emitter<ChatState> emit) async {
    emit(SignalRConnecting());
    
    final currentUser = _getCurrentUser();
    if (currentUser == null) {
      emit(const SignalRConnectionError(error: 'User not authenticated'));
      return;
    }

    final result = await connectSignalRUseCase();

    result.fold(
      (failure) {
        emit(SignalRConnectionError(error: failure.message));
      },
      (_) {
        _isSignalRConnected = true;
        _reconnectAttempts = 0;
        emit(const SignalRConnected());
        // Auto join room nếu có pending
        if (_pendingJoinChatRoomId != null) {
          add(JoinChatRoomEvent(chatRoomId: _pendingJoinChatRoomId!));
        }
      },
    );
  }

  Future<void> _onDisconnectSignalR(DisconnectSignalREvent event, Emitter<ChatState> emit) async {
    final result = await disconnectSignalRUseCase();

    result.fold(
      (failure) => emit(SignalRConnectionError(error: failure.message)),
      (_) {
        _isSignalRConnected = false;
        _currentChatRoomId = null;
        _reconnectTimer?.cancel();
        emit(const SignalRDisconnected());
      },
    );
  }

  void _onSignalRConnectionChanged(SignalRConnectionChangedEvent event, Emitter<ChatState> emit) {
    _isSignalRConnected = event.isConnected;
    
    if (event.isConnected) {
      _reconnectAttempts = 0;
      _reconnectTimer?.cancel();
      emit(const SignalRConnected());
    } else {
      emit(SignalRDisconnected(reason: event.error));
      _startAutoReconnect();
    }
  }

  // Room Join/Leave
  Future<void> _onJoinChatRoom(JoinChatRoomEvent event, Emitter<ChatState> emit) async {
    if (!_isSignalRConnected) {
      _pendingJoinChatRoomId = event.chatRoomId;
      add(const ConnectSignalREvent());
      return;
    }

    if (_currentChatRoomId != null && _currentChatRoomId != event.chatRoomId) {
      await leaveChatRoomUseCase(LeaveChatRoomParams(chatRoomId: _currentChatRoomId!));
    }

    final result = await joinChatRoomUseCase(JoinChatRoomParams(chatRoomId: event.chatRoomId));
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {
        _currentChatRoomId = event.chatRoomId;
        _pendingJoinChatRoomId = null;
        emit(ChatRoomJoined(chatRoomId: event.chatRoomId));
      },
    );
  }

  Future<void> _onLeaveChatRoom(LeaveChatRoomEvent event, Emitter<ChatState> emit) async {
    final result = await leaveChatRoomUseCase(LeaveChatRoomParams(
      chatRoomId: event.chatRoomId,
    ));

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {
        if (_currentChatRoomId == event.chatRoomId) {
          _currentChatRoomId = null;
        }
        emit(ChatRoomLeft(chatRoomId: event.chatRoomId));
      },
    );
  }

  // Shop Chat Rooms
  Future<void> _onLoadShopChatRooms(LoadShopChatRoomsEvent event, Emitter<ChatState> emit) async {
    if (event.isRefresh) {
      emit(ChatLoading());
    } else {
      emit(ChatRoomsLoading());
    }

    final result = await loadShopChatRoomsUseCase(LoadShopChatRoomsParams(
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      isActive: event.isActive,
    ));

    result.fold(
      (failure) {
        emit(ChatRoomsError(message: failure.message));
      },
      (paginatedResponse) {
        emit(ShopChatRoomsLoaded(
          chatRooms: paginatedResponse.items,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages,
          hasNext: paginatedResponse.hasNext,
          hasPrevious: paginatedResponse.hasPrevious,
          totalCount: paginatedResponse.totalCount,
          isRefresh: event.isRefresh,
        ));
      },
    );
  }

  // Unread Count
  Future<void> _onLoadUnreadCount(LoadUnreadCountEvent event, Emitter<ChatState> emit) async {
    final result = await getUnreadCountUseCase();

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (unreadCount) => emit(UnreadCountLoaded(unreadCount: unreadCount)),
    );
  }

  void _onUpdateUnreadCount(UpdateUnreadCountEvent event, Emitter<ChatState> emit) {
    emit(UnreadCountUpdated(
      chatRoomId: event.chatRoomId,
      count: event.count,
    ));
  }

  // User Presence
  void _onUserJoinedRoom(UserJoinedRoomEvent event, Emitter<ChatState> emit) {
    emit(UserJoinedRoom(
      userId: event.userId,
      chatRoomId: event.chatRoomId,
    ));
  }

  void _onUserLeftRoom(UserLeftRoomEvent event, Emitter<ChatState> emit) {
    emit(UserLeftRoom(
      userId: event.userId,
      chatRoomId: event.chatRoomId,
    ));
  }

  // Error & Utility
  void _onChatError(ChatErrorEvent event, Emitter<ChatState> emit) {
    emit(ChatError(message: event.error));
  }

  void _onClearChatState(ClearChatStateEvent event, Emitter<ChatState> emit) {
    _currentChatRoomId = null;
    _typingUsers.clear();
    emit(const ChatStateCleared());
  }

  void _onClearMessages(ClearMessagesEvent event, Emitter<ChatState> emit) {
    emit(const MessagesCleared());
  }

  void _onClearSearchResults(ClearSearchResultsEvent event, Emitter<ChatState> emit) {
    emit(const SearchResultsCleared());
  }

  // Auto-reconnect logic
  void _startAutoReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      add(const ChatErrorEvent(error: 'Max reconnection attempts reached'));
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: 2 * _reconnectAttempts);
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      add(const ConnectSignalREvent());
    });
  }

  // Helper methods để check user role - CHỈ 2 ROLE
  bool _isCustomerUser() {
    final role = _getUserRole();
    return role == UserRole.customer;
  }

  // Get current user role as UserRole enum
  UserRole? _getUserRole() {
    final currentUser = _getCurrentUser();
    final dynamic roleValue = currentUser?.role;
    if (roleValue == null) return null;
    if (roleValue is int) {
      return UserRole.fromValue(roleValue);
    }
    if (roleValue is String) {
      final v = roleValue.toLowerCase();
      if (v == 'customer') return UserRole.customer;
      if (v == 'seller') return UserRole.seller;
    }
    return null;
  }

  // Validate user role
  bool _isValidRole() {
    final userRole = _getUserRole();
    return userRole == UserRole.customer || userRole == UserRole.seller;
  }

  // Get current user helper - Enhanced with role validation
  AccountEntity? _getCurrentUser() {
    try {
      final authBloc = getIt<AuthBloc>();
      final authState = authBloc.state;
      
      if (authState is AuthSuccess) {
        final user = authState.loginResponse.account;
        // Validate role is valid (Customer or Seller)
        if (!_isValidRole()) {
          return null;
        }
        
        return user;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() async {
    // Cancel all timers first
    _reconnectTimer?.cancel();
    _typingTimer?.cancel();
    
    // Remove SignalR listeners để tránh memory leaks
    signalRService.removeListeners();
    
    // Disconnect SignalR if connected
    if (_isSignalRConnected) {
      try {
        await disconnectSignalRUseCase();
      } catch (e) {
        // Handle error silently
      }
    }
    
    // Clear internal state
    _currentChatRoomId = null;
    _typingUsers.clear();
    _isSignalRConnected = false;
    _reconnectAttempts = 0;
    
    return super.close();
  }

  // Add new event handler method
  Future<void> _onTypingReceived(TypingReceivedEvent event, Emitter<ChatState> emit) async {
    // Only emit if it's not the current user typing
    final currentUser = _getCurrentUser();
    if (currentUser != null && currentUser.id != event.userId) {
      emit(TypingIndicatorReceived(
        userId: event.userId,
        chatRoomId: event.chatRoomId,
        userName: event.userName,
        isTyping: event.isTyping,
        timestamp: event.timestamp ?? DateTime.now(),
      ));
      if (event.isTyping) {
        Timer(const Duration(seconds: 5), () {
          // Check if still in the same state and emit stop typing
          if (state is TypingIndicatorReceived) {
            final currentState = state as TypingIndicatorReceived;
            if (currentState.userId == event.userId && 
                currentState.chatRoomId == event.chatRoomId) {
              add(TypingReceivedEvent(
                userId: event.userId,
                chatRoomId: event.chatRoomId,
                userName: event.userName,
                isTyping: false,
              ));
            }
          }
        });
      }
    }
  }
}