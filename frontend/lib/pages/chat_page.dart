import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_buble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const Color bgColor = Color(0xFFF6F4F0);
  static const Color cardColor = Color(0xFFEFECE6);
  static const Color borderColor = Color(0xFFE2DDD7);
  static const Color textColor = Color(0xFF1F1D1B);
  static const Color subtitleColor = Color(0xFF8E8B85);
  static const Color badgePurple = Color(0xFF7A4A8B);

  final List<Map<String, String>> suggestionCards = const [
    {
      "title": "Ringkas dokumen ini",
      "subtitle": "dalam poin-poin penting dan mudah dipahami",
    },
    {
      "title": "Jelaskan konsep utama",
      "subtitle": "dengan contoh sederhana dari dokumen",
    },
    {
      "title": "Buat daftar pertanyaan",
      "subtitle": "untuk membantu saya mempelajari materi ini",
    },
    {
      "title": "Temukan informasi penting",
      "subtitle": "yang perlu saya perhatikan dari dokumen",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan ikon garis tiga (leading)
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1821),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "AskRiver AI",
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Tombol New Chat Baru dengan Teks dan Ikon
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: chatProvider.startNewChat,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: textColor, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "New Chat",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatProvider.messages.isEmpty
                  ? _buildEmptyState(chatProvider)
                  : _buildChatList(chatProvider),
            ),
            if (chatProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Color(0xFF6B3BA4)),
              ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ChatProvider chatProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            "Apa yang bisa saya bantu hari ini?",
            style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suggestionCards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = suggestionCards[index];
              return _buildPromptCard(
                title: item["title"]!,
                subtitle: item["subtitle"]!,
                onTap: () => chatProvider.sendMessage(item["title"]!),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(ChatProvider chatProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: chatProvider.messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(message: chatProvider.messages[index]);
      },
    );
  }

  Widget _buildPromptCard({required String title, required String subtitle, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: subtitleColor, fontSize: 13.5, height: 1.3)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.north_east_rounded, color: subtitleColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}