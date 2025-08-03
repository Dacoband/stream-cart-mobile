import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/user_role.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry!, // Use provided onRetry callback
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thử lại'),
              ),
            ] else ...[
              // Default retry logic if no onRetry provided
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _handleDefaultRetry(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleDefaultRetry(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthSuccess) {
      // If not authenticated, just show message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập lại')),
      );
      return;
    }

    final roleValue = authState.loginResponse.account.role;
    final userRole = UserRole.fromValue(roleValue);
    if (userRole == UserRole.seller) {
      context.read<ChatBloc>().add(const LoadShopChatRoomsEvent(
        pageNumber: 1,
        pageSize: 20,
        isRefresh: true,
      ));
    } else {
      context.read<ChatBloc>().add(const LoadChatRoomsEvent(
        pageNumber: 1,
        pageSize: 20,
        isRefresh: true,
      ));
    }
    context.read<ChatBloc>().add(const ConnectSignalREvent());
  }
}
