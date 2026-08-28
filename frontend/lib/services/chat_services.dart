import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/chat_response.dart";

class ChatService {
  Future<ChatResponse> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.chat),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "session_id": sessionId,
        "message": message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Gagal mengirim pesan: ${response.body}",
      );
    }

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    return ChatResponse.fromJson(data);
  }
}