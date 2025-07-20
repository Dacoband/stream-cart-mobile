import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/dependency_injection.dart';
import '../../presentation/pages/auth/login_page.dart' as auth;
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/otp_verification_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/profile/profile_detail_page.dart';
import '../../presentation/pages/product_detail/product_detail_page.dart';
import '../../presentation/pages/search/search_page.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/profile/profile_event.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String profileDetail = '/profile-detail';
  static const String productDetails = '/product-details';
  static const String search = '/search';
  static const String livestreamList = '/livestream-list';
  static const String livestreamDetail = '/livestream-detail';
  static const String cart = '/cart';
  static const String orders = '/orders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const auth.LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case otpVerification:
        final String email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationPage(email: email),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileBloc>(),
            child: const ProfilePage(),
          ),
        );
      case profileDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileBloc>()..add(LoadUserProfileEvent()),
            child: const ProfileDetailPage(),
          ),
        );
      case productDetails:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(productId: productId),
        );
      case search:
        final String? initialQuery = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => SearchPage(initialQuery: initialQuery),
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Giỏ hàng')),
            body: const Center(
              child: Text('Trang giỏ hàng đang phát triển'),
            ),
          ),
        );
      case orders:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Đơn hàng của tôi')),
            body: const Center(
              child: Text('Trang đơn hàng đang phát triển'),
            ),
          ),
        );
      case livestreamList:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Livestream')),
            body: const Center(
              child: Text('Trang livestream đang phát triển'),
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}