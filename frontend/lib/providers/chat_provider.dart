import "dart:typed_data";

import "package:flutter/foundation.dart";
import "package:uuid/uuid.dart";

import "../models/chat_message.dart";
import "../services/chat_services.dart";
import "../services/document_service.dart";

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService;
  final DocumentService _documentService;

  ChatProvider({
    ChatService? chatService,
    DocumentService? documentService,
  })  : _chatService = chatService ?? ChatService(),
        _documentService =
            documentService ?? DocumentService();

  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages =>
      List.unmodifiable(_messages);

  String _sessionId = const Uuid().v4();

  String get sessionId => _sessionId;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  String? _uploadedFilename;

  String? get uploadedFilename =>
      _uploadedFilename;

  Future<void> uploadDocument({
    required String filename,
    required Uint8List fileBytes,
  }) async {
    if (_isUploading) {
      return;
    }

    _isUploading = true;

    notifyListeners();

    try {
      await _documentService.uploadDocument(
        filename: filename,
        fileBytes: fileBytes,
      );

      _uploadedFilename = filename;
    } finally {
      _isUploading = false;

      notifyListeners();
    }
  }

Future<void> sendMessage(
  String message,
) async {
  if (message.trim().isEmpty ||
      _isLoading) {
    return;
  }

  final userMessage = message.trim();

  _messages.add(
    ChatMessage(
      content: userMessage,
      isUser: true,
    ),
  );

  _isLoading = true;

  notifyListeners();

  try {
    final response =
        await _chatService.sendMessage(
      sessionId: _sessionId,
      message: userMessage,
    );

    _messages.add(
      ChatMessage(
        content: response.answer,
        isUser: false,
        sources: response.sources,
      ),
    );
  } catch (error) {
    _messages.add(
      ChatMessage(
        content: "Terjadi kesalahan: coba cek koneksi internet anda",
        isUser: false,
      ),
    );
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
  void startNewChat() {
    _sessionId = const Uuid().v4();

    _messages.clear();

    notifyListeners();
  }
}