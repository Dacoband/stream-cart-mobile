import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/config/firebase_config.dart';
import 'core/config/env.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/services/search_history_service.dart';
import 'core/services/notification_signalr_manager.dart';
import 'core/services/firebase_notification_service.dart';
import 'domain/usecases/chat/connect_livekit_usecase.dart';
import 'domain/usecases/chat/disconnect_livekit_usecase.dart';
import 'domain/usecases/chat/load_chat_room_by_shop_usecase.dart';
import 'domain/usecases/chat/load_chat_room_usecase.dart';
import 'domain/usecases/chat/load_chat_rooms_usecase.dart';
import 'domain/usecases/chat/mark_chat_room_as_read_usecase.dart';
import 'domain/usecases/chat/receive_message_usecase.dart';
import 'domain/usecases/chat/send_message_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/chat/chat_bloc.dart';
import 'presentation/blocs/notification/notification_bloc.dart';
import 'presentation/pages/auth/auth_wrapper.dart';
import 'presentation/pages/chat/chat_list_page.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseNotificationService.instance.handleBackgroundMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await FirebaseConfig.loadEnv();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseConfig.currentPlatform,
  );
  
  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  try {
    await Env.load();
  } catch (e, s) {
    debugPrint('Env load error: $e\n$s');
  }
  
  await setupDependencies();
  
  // Initialize search history service
  await getIt.get<SearchHistoryService>().initializeHistory();
  
  // Initialize SignalR manager for real-time notifications
  NotificationSignalRManager.instance.initialize();
  
  // Initialize Firebase notifications
  await FirebaseNotificationService.instance.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return getIt<AuthBloc>();
          },
        ),
        BlocProvider.value(
          value: getIt<CartBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<NotificationBloc>(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(
            loadChatRoomUseCase: getIt<LoadChatRoomUseCase>(),
            loadChatRoomsByShopUseCase: getIt<LoadChatRoomsByShopUseCase>(),
            loadChatRoomsUseCase: getIt<LoadChatRoomsUseCase>(),
            sendMessageUseCase: getIt<SendMessageUseCase>(),
            receiveMessageUseCase: getIt<ReceiveMessageUseCase>(),
            markChatRoomAsReadUseCase: getIt<MarkChatRoomAsReadUseCase>(),
            connectLiveKitUseCase: getIt<ConnectLiveKitUseCase>(),
            disconnectLiveKitUseCase: getIt<DisconnectLiveKitUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Stream Cart Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
