class Source {
  final String content;
  final Map<String, dynamic> metadata;

  Source({
    required this.content,
    required this.metadata,
  });

  factory Source.fromJson(
    Map<String, dynamic> json,
  ) {
    return Source(
      content: json["content"] ?? "",
      metadata: Map<String, dynamic>.from(
        json["metadata"] ?? {},
      ),
    );
  }
}