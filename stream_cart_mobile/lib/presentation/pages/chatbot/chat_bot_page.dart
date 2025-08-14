import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../../blocs/chatbot/chat_bot_bloc.dart';
import '../../blocs/chatbot/chat_bot_event.dart';
import '../../blocs/chatbot/chat_bot_state.dart';
import '../../widgets/chatbot/chat_bot_message_list.dart';
import '../../widgets/chatbot/chat_bot_input.dart';
import '../../widgets/chatbot/chat_bot_history_list.dart';
import '../../theme/app_colors.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _openHistory(BuildContext context) {
  final mainBloc = context.read<ChatBotBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: BlocProvider(
              create: (_) => getIt<ChatBotBloc>()..add(const LoadChatBotHistory()),
              child: ChatBotHistoryList(
                onSelect: (item) {
                  Navigator.pop(ctx);
                  mainBloc.add(ShowChatBotItem(item));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatBotBloc>(),
      child: Builder(
        builder: (innerCtx) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.brandDark,
          title: const Text('Stream Cart AI', style: TextStyle(color: AppColors.brandAccent, fontSize: 16, fontWeight: FontWeight.w700)),
          iconTheme: const IconThemeData(color: AppColors.brandAccent),
          actionsIconTheme: const IconThemeData(color: AppColors.brandAccent),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_comment_outlined),
              tooltip: 'Chat mới',
              onPressed: () {
                innerCtx.read<ChatBotBloc>().add(const ClearChatBot());
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Lịch sử',
              onPressed: () => _openHistory(innerCtx),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBotBloc, ChatBotState>(
                  builder: (context, state) {
                    if (state is ChatBotInitial || state is ChatBotCleared) {
                      return const Center(
                        child: Text('Hãy bắt đầu trò chuyện với AI...', style: TextStyle(color: AppColors.brandDark, fontSize: 14, fontWeight: FontWeight.w500)),
                      );
                    }
                    if (state is ChatBotLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ChatBotHistoryLoaded) {
                      return ChatBotMessageList(history: state.history);
                    }
                    if (state is ChatBotError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              ChatBotInput(
                controller: _inputController,
                onSend: (text) {
                  if (text.trim().isEmpty) return;
                  innerCtx.read<ChatBotBloc>().add(SendChatBotMessage(message: text.trim()));
                  _inputController.clear();
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
