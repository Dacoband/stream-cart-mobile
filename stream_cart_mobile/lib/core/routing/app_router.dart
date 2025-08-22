import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../../presentation/blocs/address/address_bloc.dart';
import '../../presentation/pages/address/add_edit_address_page.dart';
import '../../presentation/pages/address/address_list_page.dart';
import '../../presentation/pages/chat/chat_detail_page.dart';
import '../../presentation/pages/chat/chat_list_page.dart';
import '../../presentation/pages/order/order_list_page.dart';
import '../../presentation/pages/order/order_success_page.dart';
import '../../presentation/pages/order/order_detail_page.dart';
import '../../presentation/pages/payment/payment_qr_page.dart';
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
import '../../presentation/pages/checkout/check_out_page.dart';
import '../../presentation/pages/category/category_detail_page.dart';
import '../../presentation/pages/notification/notification_page.dart';
import '../../presentation/pages/chatbot/chat_bot_page.dart';
import '../../presentation/pages/shop/shop_list_page.dart';
import '../../presentation/pages/shop/shop_detail_page.dart';
import '../../presentation/pages/livestream/livestream_page.dart';
import '../../presentation/pages/livestream/livestream_list_page.dart';
import '../../presentation/pages/cart_live/live_cart_page.dart';
import '../../presentation/blocs/cart_live/cart_live_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';
import '../../presentation/blocs/profile/profile_event.dart';
import '../../presentation/blocs/search/advanced_search_bloc.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../domain/entities/account/user_profile_entity.dart';
import '../../domain/entities/order/order_entity.dart';
import '../../presentation/blocs/review/review_bloc.dart';
import '../../presentation/pages/review/product_reviews_page.dart';
import '../../presentation/pages/review/write_review_page.dart';
import '../../presentation/pages/review/edit_review_page.dart';
import '../../presentation/pages/review/order_reviews_page.dart';
import '../../presentation/pages/review/user_reviews_page.dart';
import '../../presentation/pages/review/livestream_reviews_page.dart';
import '../../presentation/pages/review/review_detail_page.dart';
import '../../domain/entities/review/review_entity.dart';
import '../../presentation/pages/shop_voucher/shop_voucher_list_page.dart';
import '../../presentation/blocs/shop_voucher/shop_voucher_bloc.dart';
import '../di/dependency_injection.dart' show getIt;

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
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String notification = '/notification';
  static const String shopList = '/shop-list';
  static const String shopDetail = '/shop-detail';
  static const String chatList = '/chat-list';
  static const String chatDetail = '/chat-detail';
  static const String chatBot = '/chat-bot';
  static const String shopVouchers = '/shop-vouchers';
  static const String addressList = '/address-list';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String orderSuccess = '/order-success';
  static const String orderDetail = '/order-detail';
  static const String paymentQr = '/payment-qr';
  // Review
  static const String productReviews = '/product-reviews';
  static const String writeReview = '/write-review';
  static const String editReview = '/edit-review';
  static const String orderReviews = '/order-reviews';
  static const String userReviews = '/user-reviews';
  static const String livestreamReviews = '/livestream-reviews';
  static const String reviewDetail = '/review-detail';
  // Live cart
  static const String liveCart = '/live-cart';


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
        String productId;
        String? heroTag;
        String? imageUrl;
        String? name;
        double? price;
        final args = settings.arguments;
        if (args is String) {
          productId = args;
        } else if (args is Map) {
          productId = args['productId'] as String;
          heroTag = args['heroTag'] as String?;
          imageUrl = args['imageUrl'] as String?;
          name = args['name'] as String?;
          price = args['price'] is num ? (args['price'] as num).toDouble() : null;
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Thiếu productId'))),
          );
        }
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => ProductDetailPage(
            productId: productId,
            heroTag: heroTag,
            initialImageUrl: imageUrl,
            initialName: name,
            initialPrice: price,
          ),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
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
      case checkout:
        final previewOrderData = settings.arguments as PreviewOrderDataEntity?;
        if (previewOrderData == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Không tìm thấy dữ liệu đơn hàng'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => CheckoutPage(previewOrderData: previewOrderData),
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
        final String? accountId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => OrderListPage(accountId: accountId),
        );
      case orderDetail:
        final String orderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderDetailPage(orderId: orderId),
        );
      case notification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<NotificationBloc>(),
            child: const NotificationPage(),
          ),
        );
      case livestreamList:
        final args = settings.arguments as Map<String, dynamic>?;
        final shopId = args?['shopId'] as String?;
  // liveKitUrl argument deprecated; use constant
        return MaterialPageRoute(
          builder: (_) => LiveStreamListPage(
            shopId: shopId,
          ),
        );
      case livestreamDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final liveStreamId = args?['liveStreamId'] as String? ?? args?['id'] as String?;
  // liveKitUrl argument deprecated; use constant
        if (liveStreamId == null || liveStreamId.isEmpty) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Thiếu liveStreamId')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => LiveStreamPage(
            liveStreamId: liveStreamId,
          ),
        );
      case liveCart:
        final args = settings.arguments as Map<String, dynamic>?;
        final livestreamId = args?['livestreamId'] as String?;
        if (livestreamId == null || livestreamId.isEmpty) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Thiếu livestreamId'))),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<CartLiveBloc>(),
            child: LiveCartPage(livestreamId: livestreamId),
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
      case shopVouchers:
        final String shopId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ShopVoucherBloc>(),
            child: ShopVoucherListPage(shopId: shopId),
          ),
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
            shopId: args['shopId']!,
            shopName: args['shopName'] ?? '',
          ),
        );
      case chatBot:
        return MaterialPageRoute(
          builder: (_) => const ChatBotPage(),
        );
      case addressList:
        final args = settings.arguments as Map<String, dynamic>?;
        final isSelectionMode = args?['isSelectionMode'] ?? false;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AddressBloc>(),
            child: AddressListPage(isSelectionMode: isSelectionMode),
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
      case orderSuccess:
        final orders = settings.arguments as List<OrderEntity>;
        return MaterialPageRoute(
          builder: (_) => OrderSuccessPage(orders: orders),
        );
      case paymentQr:
        final args = settings.arguments as Map<String, dynamic>?;
        final orders = args?['orders'] as List<OrderEntity>?;
        final qrUrl = args?['qrUrl'] as String?;
        return MaterialPageRoute(
          builder: (_) => PaymentQrPage(
            orders: orders ?? const [],
            initialQrUrl: qrUrl,
          ),
        );
      case productReviews:
        final productId = settings.arguments as String?;
        if (productId == null || productId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu productId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: ProductReviewsPage(productId: productId),
          ),
        );
      case writeReview:
        final productId = settings.arguments as String?;
        if (productId == null || productId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu productId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: WriteReviewPage(productId: productId),
          ),
        );
      case editReview:
        final args = settings.arguments as Map<String, dynamic>?;
        final reviewId = args?['reviewId'] as String?;
        final ReviewEntity? initialReview = args?['initialReview'] as ReviewEntity?;
        if (reviewId == null || reviewId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu reviewId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: EditReviewPage(reviewId: reviewId, initialReview: initialReview),
          ),
        );
      case orderReviews:
        final orderId = settings.arguments as String?;
        if (orderId == null || orderId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu orderId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: OrderReviewsPage(orderId: orderId),
          ),
        );
      case userReviews:
        final userId = settings.arguments as String?;
        if (userId == null || userId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu userId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: UserReviewsPage(userId: userId),
          ),
        );
      case livestreamReviews:
        final livestreamId = settings.arguments as String?;
        if (livestreamId == null || livestreamId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu livestreamId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: LivestreamReviewsPage(livestreamId: livestreamId),
          ),
        );
      case reviewDetail:
        final reviewId = settings.arguments as String?;
        if (reviewId == null || reviewId.isEmpty) {
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Thiếu reviewId'))));
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReviewBloc>(),
            child: ReviewDetailPage(reviewId: reviewId),
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