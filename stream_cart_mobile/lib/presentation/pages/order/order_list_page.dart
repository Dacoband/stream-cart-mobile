import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_cart_mobile/presentation/widgets/order/order_list_body_widget.dart';

import '../../../core/di/dependency_injection.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/common/auth_guard.dart';

// Danh sách đơn hàng - SIMPLIFIED VERSION
class OrderListPage extends StatelessWidget {
  final String? accountId;

  const OrderListPage({
    Key? key,
    this.accountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color(0xFF202328),
        foregroundColor: Color(0xFFB0F847),
        elevation: 0,
      ),
      body: AuthGuard(
        message: 'Vui lòng đăng nhập để xem đơn hàng của bạn',
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            // Get accountId with priority: parameter > arguments > auth state
            final String? currentAccountId = accountId ??
                ModalRoute.of(context)?.settings.arguments as String? ??
                _getAccountIdFromAuthState(authState);

            if (currentAccountId == null) {
              return const Center(
                child: Text(
                  'Không thể tải thông tin tài khoản',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return BlocProvider(
              create: (context) => getIt<OrderBloc>(),
              child: OrderListBodyWidget(
                accountId: currentAccountId,
              ),
            );
          },
        ),
      ),
    );
  }

  String? _getAccountIdFromAuthState(AuthState authState) {
    if (authState is AuthSuccess) {
      return authState.loginResponse.account.id;
    }
    return null;
  }
}

class SimpleOrderListPage extends StatelessWidget {
  final String? accountId;

  const SimpleOrderListPage({
    Key? key,
    this.accountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AuthGuard(
        message: 'Vui lòng đăng nhập để xem danh sách đơn hàng của bạn',
        child: _buildOrderListContent(context),
      ),
    );
  }

  Widget _buildOrderListContent(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final currentAccountId = _resolveAccountId(context, authState);

          return OrderListViewWidget(
            accountId: currentAccountId,
          );
        },
      ),
    );
  }

  String _resolveAccountId(BuildContext context, AuthState authState) {
    // Priority: widget parameter > route arguments > auth state
    return accountId ??
        ModalRoute.of(context)?.settings.arguments as String? ??
        (authState is AuthSuccess ? authState.loginResponse.account.id : 'unknown');
  }
}

class RobustOrderListPage extends StatelessWidget {
  final String? accountId;

  const RobustOrderListPage({
    Key? key,
    this.accountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AuthGuard(
        message: 'Đăng nhập để xem tất cả đơn hàng và theo dõi tình trạng giao hàng',
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final currentAccountId = _resolveAccountId(context, authState);

            if (currentAccountId == null) {
              return _buildErrorView(context);
            }

            return BlocProvider(
              create: (context) => getIt<OrderBloc>(),
              child: OrderListViewWidget(
                accountId: currentAccountId,
              ),
            );
          },
        ),
      ),
    );
  }

  String? _resolveAccountId(BuildContext context, AuthState authState) {
    return accountId ??
        ModalRoute.of(context)?.settings.arguments as String? ??
        (authState is AuthSuccess ? authState.loginResponse.account.id : null);
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải thông tin tài khoản',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng thử lại sau',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}