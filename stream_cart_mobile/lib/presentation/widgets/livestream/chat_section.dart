import 'package:flutter/material.dart';

class ChatSection extends StatefulWidget {
  final List messages;
  const ChatSection({super.key, required this.messages});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final _controller = ScrollController();

  @override
  void didUpdateWidget(covariant ChatSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_controller.hasClients) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messages;
    if (messages.isEmpty) {
      return const Center(child: Text('Chưa có tin nhắn', style: TextStyle(color: Colors.white70)));
    }
    return ListView.builder(
      controller: _controller,
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
  final user = (m.senderName ?? 'User').toString();
  final content = (m.message ?? '').toString();
  return '$user: $content';
    } catch (_) {
      return m.toString();
    }
  }
}
