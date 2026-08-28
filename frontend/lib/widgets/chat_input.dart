import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/chat_provider.dart";

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(text);
      _controller.clear();
    }
  }

  Future<void> _handlePickFile() async {
    final messenger = ScaffoldMessenger.of(context);
    final chatProvider = context.read<ChatProvider>();

    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
      );

      if (file == null) return;

      final fileBytes = await file.readAsBytes();

      if (fileBytes.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Gagal membaca data file PDF")),
        );
        return;
      }

      await chatProvider.uploadDocument(
        filename: file.name,
        fileBytes: fileBytes,
      );

      // Notifikasi sukses tambahkan ke knowledge base
      messenger.showSnackBar(
        SnackBar(
          content: Text("${file.name} berhasil ditambahkan ke knowledge base"),
          backgroundColor: const Color(0xFF4A7C59),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Upload gagal: $error"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final isLoading = chatProvider.isLoading;
    final isUploading = chatProvider.isUploading;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFECE6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFE2DDD7), width: 1.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !isLoading,
                      onSubmitted: (_) => _handleSend(),
                      style: const TextStyle(color: Color(0xFF1F1D1B), fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Tanyakan apa saja...",
                        hintStyle: TextStyle(color: Color(0xFF8E8B85), fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6B3BA4),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.attach_file_rounded, color: Color(0xFF8E8B85), size: 24),
                          onPressed: _handlePickFile,
                          tooltip: "Upload PDF",
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFF6B3BA4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.near_me_rounded, color: Colors.white, size: 24),
              onPressed: isLoading ? null : _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}