import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/chatbot/chat_bot_entity.dart';

import '../../blocs/chatbot/chat_bot_bloc.dart';
import '../../blocs/chatbot/chat_bot_state.dart';

class ChatBotHistoryList extends StatelessWidget {
  final void Function(ChatBotHistoryItem item) onSelect;

  const ChatBotHistoryList({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Lịch sử chat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<ChatBotBloc, ChatBotState>(
              builder: (context, state) {
                if (state is ChatBotHistoryLoaded) {
                  final items = state.history.history.reversed.toList();
                  if (items.isEmpty) {
                    return const Center(child: Text('Chưa có lịch sử chat'));
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final title = item.userMessage.trim();
                      return ListTile(
                        title: Text(
                          title.isEmpty ? '(Tin nhắn rỗng)' : title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          item.aiResponse,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => onSelect(item),
                      );
                    },
                  );
                }
                if (state is ChatBotLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
