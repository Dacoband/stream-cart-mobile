import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ChatBotInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String text) onSend;

  const ChatBotInput({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn... ',
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFFF7F8F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.brandAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => onSend(controller.text),
              icon: const Icon(Icons.send),
              color: AppColors.brandDark,
            ),
          ],
        ),
      ),
    );
  }
}
