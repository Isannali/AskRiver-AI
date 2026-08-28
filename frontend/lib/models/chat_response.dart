import "source.dart";

class ChatResponse {
  final String sessionId;
  final String answer;
  final List<Source> sources;

  ChatResponse({
    required this.sessionId,
    required this.answer,
    required this.sources,
  });

  factory ChatResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatResponse(
      sessionId: json["session_id"] as String,
      answer: json["answer"] as String,
      sources: (json["sources"] as List<dynamic>? ?? [])
          .map(
            (item) => Source.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}