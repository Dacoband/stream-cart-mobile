import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chatbot/chat_bot_entity.dart';
import '../../blocs/chatbot/chat_bot_bloc.dart';
import '../../blocs/chatbot/chat_bot_state.dart';

class ChatBotMessageList extends StatefulWidget {
  final ChatBotHistoryEntity history;

  const ChatBotMessageList({super.key, required this.history});

  @override
  State<ChatBotMessageList> createState() => _ChatBotMessageListState();
}

class _ChatBotMessageListState extends State<ChatBotMessageList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animated: false));
  }

  @override
  void didUpdateWidget(covariant ChatBotMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLen = oldWidget.history.history.length;
    final newLen = widget.history.history.length;
    final changedLen = newLen != oldLen;
    final oldLast = oldLen > 0 ? oldWidget.history.history.last : null;
    final newLast = newLen > 0 ? widget.history.history.last : null;
    final changedLast = oldLast?.aiResponse != newLast?.aiResponse || oldLast?.userMessage != newLast?.userMessage;
    if (changedLen || changedLast) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_controller.hasClients) return;
    final target = _controller.position.maxScrollExtent;
    if (animated) {
      _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _controller.jumpTo(target);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.history.history;
    return BlocListener<ChatBotBloc, ChatBotState>(
      listenWhen: (prev, curr) => curr is ChatBotHistoryLoaded,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      },
      child: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 6, bottom: 6, left: 64),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    item.userMessage,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              if ((item.aiResponse).isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 0, bottom: 6, right: 64),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      item.aiResponse,
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 0, bottom: 6, right: 64),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('AI đang trả lời...'),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
