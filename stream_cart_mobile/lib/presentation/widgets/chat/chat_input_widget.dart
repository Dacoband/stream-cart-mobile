// Cho phép người dùng nhập và gửi tin nhắn.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSend; 
  final String? chatRoomId;

  const ChatInputWidget({
    super.key,
    required this.onSend,
    this.chatRoomId,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  late TextEditingController textController;
  bool _isTyping = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isCurrentlyTyping = textController.text.trim().isNotEmpty;
    
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
      
      // Send typing indicator if chat room ID is available
      if (widget.chatRoomId != null) {
        context.read<ChatBloc>().add(SendTypingIndicatorEvent(
          chatRoomId: widget.chatRoomId!,
          isTyping: isCurrentlyTyping,
        ));
      }
    }
  }

  void _sendMessage() {
    final message = textController.text.trim();
    if (message.isNotEmpty && !_isSending) {
      setState(() {
        _isSending = true;
      });
      
      widget.onSend(message);
      textController.clear();
      
      // Reset typing state
      setState(() {
        _isTyping = false;
        _isSending = false;
      });
      
      // Send stop typing indicator
      if (widget.chatRoomId != null) {
        context.read<ChatBloc>().add(SendTypingIndicatorEvent(
          chatRoomId: widget.chatRoomId!,
          isTyping: false,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        // Reset sending state when message sent successfully or failed
        if (state is MessageSent || state is MessageSendError) {
          setState(() {
            _isSending = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 108, 218, 45).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Attach file button (optional)
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.grey),
              onPressed: () {
                // TODO: Handle file attachment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đính kèm đang phát triển')),
                );
              },
            ),
            
            // Text input field
            Expanded(
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  hintStyle: TextStyle(color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                style: const TextStyle(color: Colors.black87),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            
            // Send button
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final isConnected = state is SignalRConnected || 
                                    state is ChatRoomJoined ||
                                    state is MessageSent ||
                                    state is MessageReceived;
                
                return IconButton(
                  icon: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB0F847)),
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: isConnected && _isTyping
                              ? const Color(0xFFB0F847)
                              : Colors.grey,
                        ),
                  onPressed: isConnected && !_isSending && _isTyping
                      ? _sendMessage
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}