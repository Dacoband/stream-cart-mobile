import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/domain/entities/cart/cart_entity.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_event.dart';
import '../../blocs/deliveries/deliveries_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/payment/payment_bloc.dart';
import 'check_out_view.dart';
import '../../blocs/shop_voucher/shop_voucher_bloc.dart';

class CheckoutPage extends StatelessWidget {
  final PreviewOrderDataEntity previewOrderData;
  final List<String>? liveCartItemIds; // IDs from live cart (selected)
  final String? livestreamId; // live stream context

  const CheckoutPage({
    super.key,
    required this.previewOrderData,
    this.liveCartItemIds,
    this.livestreamId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressBloc>(
          create: (context) => getIt<AddressBloc>()
            ..add(const GetDefaultShippingAddressEvent()),
        ),
        BlocProvider<DeliveryBloc>(
          create: (context) => getIt<DeliveryBloc>(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => getIt<OrderBloc>(),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => getIt<PaymentBloc>(),
        ),
        BlocProvider<ShopVoucherBloc>(
          create: (context) => getIt<ShopVoucherBloc>(),
        ),
      ],
      child: CheckoutView(
        previewOrderData: previewOrderData,
        liveCartItemIds: liveCartItemIds,
        livestreamId: livestreamId,
      ),
    );
  }
}