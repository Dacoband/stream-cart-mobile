import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/blocs/address/address_bloc.dart';
import '../../presentation/pages/address/add_edit_address_page.dart';
import '../../presentation/pages/address/address_list_page.dart';
import '../../presentation/pages/chat/chat_detail_page.dart';
import '../../presentation/pages/chat/chat_list_page.dart';
import '../di/dependency_injection.dart';
import '../../presentation/pages/auth/login_page.dart' as auth;
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/otp_verification_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/profile/profile_detail_page.dart';
import '../../presentation/pages/profile/edit_profile_page.dart';
import '../../presentation/pages/product_detail/product_detail_page.dart';
import '../../presentation/pages/search/search_page.dart';
import '../../presentation/pages/search/advanced_search_page.dart';
import '../../presentation/pages/cart/cart_page.dart';
import '../../presentation/pages/category/category_detail_page.dart';
import '../../presentation/pages/notification/notification_page.dart';
import '../../presentation/pages/shop/shop_list_page.dart';
import '../../presentation/pages/shop/shop_detail_page.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/profile/profile_event.dart';
import '../../presentation/blocs/search/advanced_search_bloc.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../domain/entities/account/user_profile_entity.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String profileDetail = '/profile-detail';
  static const String editProfile = '/edit-profile';
  static const String productDetails = '/product-details';
  static const String search = '/search';
  static const String advancedSearch = '/advanced-search';
  static const String categoryDetail = '/category-detail';
  static const String livestreamList = '/livestream-list';
  static const String livestreamDetail = '/livestream-detail';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String notification = '/notification';
  static const String shopList = '/shop-list';
  static const String shopDetail = '/shop-detail';
  static const String chatList = '/chat-list';
  static const String chatDetail = '/chat-detail';
  static const String addressList = '/address-list';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';


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
      case editProfile:
        final UserProfileEntity currentProfile = settings.arguments as UserProfileEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileBloc>(),
            child: EditProfilePage(currentProfile: currentProfile),
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
      case advancedSearch:
        final String? initialQuery = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<AdvancedSearchBloc>(),
              ),
              BlocProvider(
                create: (context) => getIt<HomeBloc>(),
              ),
            ],
            child: AdvancedSearchPage(initialQuery: initialQuery),
          ),
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartPage(), 
        );
      case categoryDetail:
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final String categoryId = args['categoryId'] as String;
        final String? categoryName = args['categoryName'] as String?;
        return MaterialPageRoute(
          builder: (_) => CategoryDetailPage(
            categoryId: categoryId,
            categoryName: categoryName,
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
      case notification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<NotificationBloc>(),
            child: const NotificationPage(),
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
      case shopList:
        return MaterialPageRoute(
          builder: (_) => const ShopListPage(),
        );
      case shopDetail:
        final String shopId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ShopDetailPage(shopId: shopId),
        );
      case chatList:
        return MaterialPageRoute(
          builder: (_) => ChatListPage(),
        );
      case chatDetail:
        final args = settings.arguments as Map<String, String>?;
        if (args == null || !args.containsKey('chatRoomId') || !args.containsKey('userId') || !args.containsKey('userName')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Lỗi')),
              body: const Center(child: Text('Thiếu thông tin phòng chat')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ChatDetailPage(
            chatRoomId: args['chatRoomId']!,
            userId: args['userId']!,
            userName: args['userName']!,
          ),
        );
      case addressList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AddressBloc>(),
            child: const AddressListPage(),
          ),
        );

      case addAddress:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AddressBloc>(),
            child: const AddEditAddressPage(),
          ),
        );

      case editAddress:
        final args = settings.arguments as Map<String, dynamic>?;
        final address = args?['address'];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AddressBloc>(),
            child: AddEditAddressPage(
              initialAddress: address,
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