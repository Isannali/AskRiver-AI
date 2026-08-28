import "package:flutter/material.dart";

import "../models/chat_message.dart";
import "source_list.dart";

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  // Skema Warna Sesuai UI Baru
  static const Color userBubbleColor = Color(0xFF6B3BA4); // Aksen Ungu
  static const Color aiBubbleColor = Color(0xFFEFECE6);   // Warm Off-White
  static const Color aiBorderColor = Color(0xFFE2DDD7);
  static const Color textDark = Color(0xFF1F1D1B);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isUser ? userBubbleColor : aiBubbleColor,
            borderRadius: BorderRadius.circular(20),
            border: isUser ? null : Border.all(color: aiBorderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Row(
                  children: const [
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 18,
                      color: userBubbleColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "AskRiver AI",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: userBubbleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: isUser ? Colors.white : textDark,
                ),
              ),
              if (!isUser)
                SourceList(
                  sources: message.sources,
                  answer: message.content,
                ),
            ],
          ),
        ),
      ),
    );
  }
}