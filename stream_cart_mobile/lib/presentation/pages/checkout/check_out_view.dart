import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_event.dart';
import '../../blocs/address/address_state.dart';
import '../../blocs/deliveries/deliveries_bloc.dart';
import '../../blocs/deliveries/deliveries_event.dart';
import '../../blocs/deliveries/deliveries_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../domain/entities/cart/cart_entity.dart';
import '../../../domain/entities/address/address_entity.dart';
import '../../../domain/entities/order/create_order_request_entity.dart';
import '../../../core/routing/app_router.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/payment/payment_state.dart';
import '../../blocs/cart/cart_event.dart';
import '../../widgets/checkout/checkout_address_widget.dart';
import '../../widgets/checkout/checkout_order_summary_widget.dart';
import '../../widgets/checkout/checkout_delivery_options_widget.dart';
import '../../widgets/checkout/checkout_payment_method_widget.dart';
import '../../widgets/checkout/bottom_bar_widget.dart';

class CheckoutView extends StatefulWidget {
  final PreviewOrderDataEntity previewOrderData;

  const CheckoutView({
    super.key,
    required this.previewOrderData,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPaymentMethod = 'COD'; 
  AddressEntity? selectedShippingAddress; 
  
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF202328),
        foregroundColor: const Color(0xFFB0F847),
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddressBloc, AddressState>(
            listener: (context, addressState) {
              if (addressState is DefaultShippingAddressLoaded) {
                if (selectedShippingAddress == null) {
                  setState(() {
                    selectedShippingAddress = addressState.address;
                  });
                }
                final addressToUse = selectedShippingAddress ?? addressState.address;
                if (addressToUse != null) {
                  context.read<DeliveryBloc>().add(
                    PreviewOrderDeliveryEvent(
                      previewOrderData: widget.previewOrderData,
                      shippingAddress: addressToUse,
                    ),
                  );
                }
              } else if (addressState is AddressError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(addressState.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          
          // Delivery Bloc Listener
          BlocListener<DeliveryBloc, DeliveryState>(
            listener: (context, deliveryState) {
              if (deliveryState is DeliveryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(deliveryState.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          
          // Order Bloc Listener
          BlocListener<OrderBloc, OrderState>(
            listener: (context, orderState) {
              if (orderState is OrdersCreated) {
                final cartItemIds = widget.previewOrderData.listCartItem
                    .expand((shop) => shop.products)
                    .map((item) => item.cartItemId)
                    .toList();
                if (cartItemIds.isNotEmpty) {
                  context.read<CartBloc>().add(
                        RemoveSelectedCartItemsEvent(cartItemIds: cartItemIds),
                      );
                }
                final isBankTransfer = selectedPaymentMethod == 'BANK_TRANSFER';
                if (isBankTransfer) {
                  // Điều hướng tới trang QR
                  Navigator.pushNamed(
                    context,
                    AppRouter.paymentQr,
                    arguments: {
                      'orders': orderState.orders,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đơn hàng đã được tạo thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.orderSuccess,
                    (route) => route.settings.name == AppRouter.home,
                    arguments: orderState.orders,
                  );
                }
              } else if (orderState is OrderError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(orderState.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          // Payment listener (optional future updates)
          BlocListener<PaymentBloc, PaymentState>(
            listener: (context, paymentState) {
              if (paymentState is PaymentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(paymentState.message), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Shipping Address Section
                    BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, addressState) {
                        return CheckoutAddressWidget(
                          addressState: addressState,
                          selectedAddress: selectedShippingAddress,
                          onChangeAddress: () => _showAddressSelection(context),
                          onAddAddress: () => _showAddAddressPage(context),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 2. Order Summary Section
                    BlocBuilder<DeliveryBloc, DeliveryState>(
                      builder: (context, deliveryState) {
                        return CheckoutOrderSummaryWidget(
                          previewOrderData: widget.previewOrderData,
                          deliveryState: deliveryState,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 3. Delivery Options Section
                    BlocBuilder<DeliveryBloc, DeliveryState>(
                      builder: (context, deliveryState) {
                        return CheckoutDeliveryOptionsWidget(
                          deliveryState: deliveryState,
                          totalOrderAmount: widget.previewOrderData.totalAmount,
                          onServiceSelected: (shopId, serviceTypeId) {
                            context.read<DeliveryBloc>().add(
                              SelectDeliveryServiceEvent(
                                shopId: shopId,
                                serviceTypeId: serviceTypeId,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 4. Payment Method Section
                    CheckoutPaymentMethodWidget(
                      selectedPaymentMethod: selectedPaymentMethod,
                      onPaymentMethodChanged: (method) {
                        if (method != null) {
                          setState(() {
                            selectedPaymentMethod = method;
                          });
                        }
                      },
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<DeliveryBloc, DeliveryState>(
        builder: (context, deliveryState) {
          return CheckoutBottomBarWidget(
            previewOrderData: widget.previewOrderData,
            deliveryState: deliveryState,
            selectedPaymentMethod: selectedPaymentMethod,
            onPlaceOrder: () => _handlePlaceOrder(context, deliveryState),
          );
        },
      ),
    );
  }

  void _showAddAddressPage(BuildContext context) {
    Navigator.pushNamed(context, AppRouter.addAddress).then((result) {
      if (result == true) {
        context.read<AddressBloc>().add(const GetDefaultShippingAddressEvent());
      }
    });
  }

  void _showAddressSelection(BuildContext context) {
    Navigator.pushNamed(
      context, 
      AppRouter.addressList,
      arguments: {'isSelectionMode': true},
    ).then((selectedAddress) {
      if (selectedAddress != null && selectedAddress is AddressEntity) {
        setState(() {
          selectedShippingAddress = selectedAddress;
        });
        context.read<DeliveryBloc>().add(
          PreviewOrderDeliveryEvent(
            previewOrderData: widget.previewOrderData,
            shippingAddress: selectedAddress,
          ),
        );
      }
    });
  }

  void _handlePlaceOrder(BuildContext context, DeliveryState deliveryState) {
    if (deliveryState is! DeliveryLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn phương thức giao hàng'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!deliveryState.hasSelectedAllServices) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn phương thức giao hàng cho tất cả shop'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận đặt hàng'),
        content: const Text('Bạn có chắc chắn muốn đặt hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _createOrder(context, deliveryState);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Đặt hàng'),
          ),
        ],
      ),
    );
  }

  void _createOrder(BuildContext context, DeliveryLoaded deliveryState) {
    // Create order request
    final orderRequest = CreateOrderRequestEntity(
      paymentMethod: selectedPaymentMethod,
      addressId: deliveryState.shippingAddress.id,
      ordersByShop: widget.previewOrderData.listCartItem.map((shop) {
        final selectedService = deliveryState.getSelectedServiceForShop(shop.shopId);
        
        // Use the same hardcoded GUID as in web app
        const shippingProviderId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";
        
        return OrderByShopEntity(
          shopId: shop.shopId,
          shippingProviderId: shippingProviderId,
          shippingFee: selectedService?.totalAmount ?? 0.0,
          expectedDeliveryDay: selectedService?.expectedDeliveryDate.toIso8601String(),
          customerNotes: "",
          items: shop.products.map((product) {
            return CreateOrderItemEntity(
              productId: product.productId,
              variantId: product.variantId,
              quantity: product.quantity,
            );
          }).toList(),
        );
      }).toList(),
    );
    
    context.read<OrderBloc>().add(
      CreateMultipleOrdersEvent(request: orderRequest),
    );
  }
}