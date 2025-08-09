import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order_item/order_item_bloc.dart';
import '../../widgets/order_detail/order_detail_view_widget.dart';

// Chi tiết đơn hàng
class OrderDetailPage extends StatelessWidget {
  final String orderId;

  OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<OrderBloc>()),
        BlocProvider(create: (context) => getIt<OrderItemBloc>()),
      ],
      child: OrderDetailViewWidget(orderId: orderId),
    );
  }
}