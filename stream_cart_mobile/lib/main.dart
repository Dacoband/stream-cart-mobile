import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/config/firebase_config.dart';
import 'core/config/env.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/services/signalr_service.dart';
import 'core/services/search_history_service.dart';
import 'core/services/notification_signalr_manager.dart';
import 'core/services/firebase_notification_service.dart';
import 'domain/usecases/chat/connect_livekit_usecase.dart';
import 'domain/usecases/chat/disconnect_livekit_usecase.dart';
import 'domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import 'domain/usecases/chat/load_chat_room_usecase.dart';
import 'domain/usecases/chat/load_chat_rooms_usecase.dart';
import 'domain/usecases/chat/load_shop_chat_rooms_usecase.dart';
import 'domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import 'domain/usecases/chat/receive_message_usecase.dart';
import 'domain/usecases/chat/send_message_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/chat/chat_bloc.dart';
import 'presentation/blocs/chat/chat_event.dart';
import 'presentation/blocs/notification/notification_bloc.dart';
import 'presentation/blocs/address/address_bloc.dart';
import 'presentation/pages/auth/auth_wrapper.dart';
import 'presentation/pages/chat/chat_list_page.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseNotificationService.instance.handleBackgroundMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseConfig.loadEnv();
  
  await Firebase.initializeApp(
    options: FirebaseConfig.currentPlatform,
  );
  
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  try {
    await Env.load();
  } catch (e, s) {
    debugPrint('Env load error: $e\n$s');
  }
  
  await setupDependencies();
  
  await getIt.get<SearchHistoryService>().initializeHistory();
  
  // Initialize SignalR manager for real-time notifications
  NotificationSignalRManager.instance.initialize();
  
  // Initialize Firebase notifications
  await FirebaseNotificationService.instance.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        print('📱 App resumed - checking connection');
        _checkAndReconnectIfNeeded();
        break;
      case AppLifecycleState.paused:
        print('📱 App paused - keeping connection active');
        break;
      case AppLifecycleState.detached:
        print('📱 App detached - disconnecting LiveKit');
        _disconnectLiveKit();
        break;
      case AppLifecycleState.inactive:
        print('📱 App inactive');
        break;
      case AppLifecycleState.hidden:
        print('📱 App hidden');
        break;
    }
  }

  void _checkAndReconnectIfNeeded() {
    try {
      final livekitService = getIt<LivekitService>();
      if (!livekitService.isConnected) {
        print('🔄 LiveKit not connected, triggering status check');
        final chatBloc = getIt<ChatBloc>();
        chatBloc.add(const ChatLiveKitStatusChanged('🔄 App resumed - checking connection'));
      }
    } catch (e) {
      print('Error checking connection: $e');
    }
  }

  void _disconnectLiveKit() {
    try {
      final chatBloc = getIt<ChatBloc>();
      chatBloc.add(const DisconnectGlobalLiveKit());
    } catch (e) {
      print('Error disconnecting LiveKit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider.value(
          value: getIt<CartBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<NotificationBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<AddressBloc>(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(
            loadChatRoomUseCase: getIt<LoadChatRoomUseCase>(),
            loadChatRoomsUseCase: getIt<LoadChatRoomsUseCase>(),
            loadChatRoomsByShopUseCase: getIt<LoadChatRoomsByShopUseCase>(),
            loadShopChatRoomsUseCase: getIt<LoadShopChatRoomsUseCase>(),
            sendMessageUseCase: getIt<SendMessageUseCase>(),
            receiveMessageUseCase: getIt<ReceiveMessageUseCase>(),
            markChatRoomAsReadUseCase: getIt<MarkChatRoomAsReadUseCase>(),
            connectLiveKitUseCase: getIt<ConnectLiveKitUseCase>(),
            disconnectLiveKitUseCase: getIt<DisconnectLiveKitUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stream Cart',
        onGenerateRoute: AppRouter.generateRoute,
        navigatorObservers: [routeObserver],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
