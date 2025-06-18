import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/env.dart';
import 'core/di/dependency_injection.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Load environment variables
  try {
    await Env.load();
  } catch (e) {
    print("Error loading .env file: $e");
  }
  
  // Setup dependencies
  await setupDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Cart Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: const LoginPage(),
      ),
    );
  }
}
