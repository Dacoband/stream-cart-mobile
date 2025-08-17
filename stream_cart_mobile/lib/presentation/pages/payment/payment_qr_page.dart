import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../../blocs/payment/payment_event.dart';
import '../../blocs/payment/payment_state.dart';
import '../../../domain/entities/payment/payment_entity.dart';
import '../../../domain/usecases/order/get_order_by_id_usecase.dart';
import '../../../core/routing/app_router.dart';

class PaymentQrPage extends StatefulWidget {
  final List<OrderEntity> orders;
  final String? initialQrUrl;
  const PaymentQrPage({super.key, required this.orders, this.initialQrUrl});

  @override
  State<PaymentQrPage> createState() => _PaymentQrPageState();
}

class _PaymentQrPageState extends State<PaymentQrPage> {
  late List<OrderEntity> _orders;
  Timer? _pollTimer;
  bool _navigated = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _orders = List<OrderEntity>.from(widget.orders);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPolling());
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) => _refreshStatuses());
  }

  Future<void> _refreshStatuses() async {
    if (_navigated || _isRefreshing) return;
    _isRefreshing = true;
    final getOrderById = getIt<GetOrderByIdUseCase>();
    final updated = <OrderEntity>[];
    for (final o in _orders) {
      final res = await getOrderById(GetOrderByIdParams(id: o.id));
      res.fold((_) => updated.add(o), (newO) => updated.add(newO));
    }
    if (!mounted) return;
    setState(() => _orders = updated);
    _evaluateAndNavigate();
    _isRefreshing = false;
  }

  void _evaluateAndNavigate() {
    if (_navigated) return;
    final anyFailed = _orders.any((o) => o.paymentStatus == 2);
    final allPaid = _orders.isNotEmpty && _orders.every((o) => o.paymentStatus == 1);
    if (anyFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán thất bại cho một hoặc nhiều đơn hàng'), backgroundColor: Colors.red),
      );
      _pollTimer?.cancel();
    } else if (allPaid) {
      _navigated = true;
      _pollTimer?.cancel();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.orderSuccess,
        (route) => route.settings.name == AppRouter.home,
        arguments: _orders,
      );
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  String _statusText(int status) {
    switch (status) {
      case 1:
        return 'Paid';
      case 2:
        return 'Failed';
      default:
        return 'Pending';
    }
  }

  Color _statusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentBloc>(
      create: (_) => getIt<PaymentBloc>()
        ..add(GeneratePaymentQrEvent(
          request: GeneratePaymentQrRequestEntity(
            orderIds: _orders.map((o) => o.id).toList(),
          ),
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán bằng QR'),
          backgroundColor: const Color(0xFF202328),
          foregroundColor: const Color(0xFFB0F847),
          actions: [
            TextButton(
              onPressed: () {
                _pollTimer?.cancel();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.orders,
                    (route) => route.settings.name == AppRouter.home,
                  );
                }
              },
              child: const Text('Hủy', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                      if (state is PaymentGenerating) {
                        return const CircularProgressIndicator();
                      } else if (state is PaymentError) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                            const SizedBox(height: 12),
                            Text(state.message, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => context.read<PaymentBloc>().add(
                                    GeneratePaymentQrEvent(
                                      request: GeneratePaymentQrRequestEntity(
                                        orderIds: _orders.map((o) => o.id).toList(),
                                      ),
                                    ),
                                  ),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        );
                      } else if (state is PaymentQrLoaded) {
                        return _buildQrContent(state.qr.qrImageUrl);
                      } else if (state is PaymentOperationSuccess) {
                        final last = context.read<PaymentBloc>().lastQr;
                        if (last != null) return _buildQrContent(last.qrImageUrl);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildOrdersStatusList(),
              _buildPaymentStatusSummary(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrContent(String url) {
    final uri = Uri.tryParse(url);
    final isValid = uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isValid
              ? Image.network(
                  url,
                  width: 240,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 120, color: Colors.grey),
                )
              : SizedBox(
                  width: 240,
                  height: 240,
                  child: Center(
                    child: Text(
                      'Không thể hiển thị QR\nURL không hợp lệ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Quét QR để thanh toán',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        if (!isValid) ...[
          const SizedBox(height: 8),
          SelectableText(
            url,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentStatusSummary() {
    final anyFailed = _orders.any((o) => o.paymentStatus == 2);
    final allPaid = _orders.isNotEmpty && _orders.every((o) => o.paymentStatus == 1);
    final summaryText = anyFailed
        ? 'Có đơn hàng thanh toán thất bại'
        : allPaid
            ? 'Tất cả đơn hàng đã thanh toán thành công'
            : 'Đang chờ thanh toán';
    final color = anyFailed
        ? Colors.red
        : allPaid
            ? Colors.green
            : Colors.orange.shade700;
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _StatusChip(label: 'Pending', color: Colors.orange),
            SizedBox(width: 8),
            _StatusChip(label: 'Paid', color: Colors.green),
            SizedBox(width: 8),
            _StatusChip(label: 'Failed', color: Colors.red),
          ],
        ),
        const SizedBox(height: 12),
        Text(summaryText, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildOrdersStatusList() {
    if (_orders.isEmpty) return const SizedBox.shrink();
    return Column(
      children: _orders
          .map(
            (o) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      o.orderCode,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(o.paymentStatus).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _statusText(o.paymentStatus),
                      style: TextStyle(
                        fontSize: 11,
                        color: _statusColor(o.paymentStatus),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color.withOpacity(0.15),
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

