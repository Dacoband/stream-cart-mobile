import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/firebase_notification_service.dart';

class FirebaseTokenWidget extends StatefulWidget {
  const FirebaseTokenWidget({super.key});

  @override
  State<FirebaseTokenWidget> createState() => _FirebaseTokenWidgetState();
}

class _FirebaseTokenWidgetState extends State<FirebaseTokenWidget> {
  String? _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final token = await FirebaseNotificationService.instance.getToken();
      if (mounted) {
        setState(() {
          _token = token;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _token = 'Error loading token';
          _isLoading = false;
        });
      }
    }
  }

  void _copyToken() {
    if (_token != null && _token != 'Error loading token') {
      Clipboard.setData(ClipboardData(text: _token!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📋 FCM Token đã được copy!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Firebase Token (Debug)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!_isLoading && _token != null && _token != 'Error loading token')
                  IconButton(
                    onPressed: _copyToken,
                    icon: const Icon(Icons.copy, size: 20),
                    tooltip: 'Copy token',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Đang tải token...'),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_token == 'Error loading token')
                      const Text(
                        'Lỗi khi tải FCM token. Hãy chắc chắn Firebase đã được cấu hình đúng.',
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Token để test push notifications:',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            _token ?? 'No token available',
                            style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            if (!_isLoading && _token != null && _token != 'Error loading token')
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '💡 Dùng token này để test notifications từ Firebase Console hoặc server',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
