import "source.dart";

class ChatMessage {
  final String content;
  final bool isUser;
  final List<Source> sources;

  ChatMessage({
    required this.content,
    required this.isUser,
    this.sources = const [],
  });
}