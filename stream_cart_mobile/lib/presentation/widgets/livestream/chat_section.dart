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
      padding: const EdgeInsets.only(bottom: 80, left: 12, right: 12, top: 8),
      itemCount: messages.length,
      itemBuilder: (c, i) {
        final m = messages[i];
        return _buildBubble(m);
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

  Widget _buildBubble(dynamic m) {
    final text = _formatMsg(m);
    final name = _safe(() => (m.senderName ?? 'User').toString());
    final content = _safe(() => (m.message ?? '').toString());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF202328),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E33), width: 1),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$name: ',
              style: const TextStyle(
                color: Color(0xFFB0F847),
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: content.isEmpty ? text : content,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _safe(String Function() f) {
    try { return f(); } catch (_) { return ''; }
  }
}
