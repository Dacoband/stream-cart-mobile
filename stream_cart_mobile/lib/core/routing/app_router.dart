// import 'package:flutter/material.dart';

// class AppRouter {  static const String login = '/login';
//   static const String signup = '/signup';
//   static const String home = '/home';
//   static const String productDetails = '/product-details';
//   static const String livestreamList = '/livestream-list';
//   static const String livestreamDetail = '/livestream-detail';
//   static const String cart = '/cart';

//   // Define other route names as constants
  
//   static Map<String, WidgetBuilder> getRoutes() {
//     return {
//       login: (context) => const LoginPage(),
//       signup: (context) => const SignupPage(),
//       home: (context) => const HomePage(),
//       livestreamList: (context) => const LiveStreamListPage(),      livestreamDetail: (context) {
//         final args = ModalRoute.of(context)!.settings.arguments as String;
//         return LiveStreamDetailPage(liveStreamId: args);
//       },
//       cart: (context) => const CartPage(),
//       // Add other routes
//     };
//   }
// }