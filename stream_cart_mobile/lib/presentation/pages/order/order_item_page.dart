import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/widgets/order_item/order_item_detail_view_widget.dart';

import '../../../core/di/dependency_injection.dart';
import '../../blocs/order_item/order_item_bloc.dart';

class OrderItemDetailPage extends StatelessWidget {
  final String itemId;

  OrderItemDetailPage({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderItemBloc>(),
      child: OrderItemDetailViewWidget(itemId: itemId),
    );
  }
}