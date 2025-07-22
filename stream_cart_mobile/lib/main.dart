import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/env.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/services/search_history_service.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/pages/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Env.load();
  } catch (e) {
    
  }
  
  await setupDependencies();
  
  // Initialize search history service
  await getIt.get<SearchHistoryService>().initializeHistory();
  
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
            print('Creating AuthBloc from main.dart');
            return getIt<AuthBloc>();
          },
        ),
        BlocProvider.value(
          value: getIt<CartBloc>(),
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
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
