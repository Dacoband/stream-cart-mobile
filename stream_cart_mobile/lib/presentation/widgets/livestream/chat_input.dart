import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_event.dart';

class LiveStreamChatInput extends StatefulWidget {
  final String liveStreamId;
  const LiveStreamChatInput({super.key, required this.liveStreamId});

  @override
  State<LiveStreamChatInput> createState() => _LiveStreamChatInputState();
}

class _LiveStreamChatInputState extends State<LiveStreamChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    context.read<LiveStreamBloc>().add(SendLiveStreamMessageEvent(
      liveStreamId: widget.liveStreamId,
      message: text,
    ));
    _controller.clear();
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: const Color(0xFF15181C),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF202328),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: _sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send, color: Color(0xFFB0F847)),
              onPressed: _sending ? null : _send,
            ),
          ],
        ),
      ),
    );
  }
}
