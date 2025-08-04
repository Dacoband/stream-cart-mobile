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
        print('📱 App resumed - checking SignalR connection');
        _checkAndReconnectSignalR();
        break;
      case AppLifecycleState.paused:
        print('📱 App paused - keeping SignalR connection active');
        break;
      case AppLifecycleState.detached:
        print('📱 App detached - disconnecting SignalR');
        _disconnectSignalR();
        break;
      case AppLifecycleState.inactive:
        print('📱 App inactive');
        break;
      case AppLifecycleState.hidden:
        print('📱 App hidden');
        break;
    }
  }

  void _checkAndReconnectSignalR() {
    try {
      final signalRService = getIt<SignalRService>();
      if (!signalRService.isConnected) {
        print('🔄 SignalR not connected, attempting reconnection');
        final chatBloc = getIt<ChatBloc>();
        chatBloc.add(const ConnectSignalREvent());
      }
    } catch (e) {
      print('Error checking SignalR connection: $e');
    }
  }

  void _disconnectSignalR() {
    try {
      final chatBloc = getIt<ChatBloc>();
      chatBloc.add(const DisconnectSignalREvent());
    } catch (e) {
      print('Error disconnecting SignalR: $e');
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
          create: (context) => getIt<ChatBloc>(),
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