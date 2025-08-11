import 'package:flutter/material.dart';

class ChatSection extends StatelessWidget {
  final List messages;
  const ChatSection({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(child: Text('Chưa có tin nhắn', style: TextStyle(color: Colors.white70)));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80, left: 12, right: 12, top: 4),
      itemCount: messages.length,
      itemBuilder: (c, i) {
        final m = messages[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            _formatMsg(m),
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  String _formatMsg(dynamic m) {
    try {
      final user = m.senderName ?? 'User';
      final content = m.content ?? '';
      return '$user: $content';
    } catch (_) {
      return m.toString();
    }
  }
}
