import "dart:convert";
import "dart:typed_data";

import "package:http/http.dart" as http;

import "../config/api_config.dart";

class DocumentService {
  Future<Map<String, dynamic>> uploadDocument({
    required String filename,
    required Uint8List fileBytes,
  }) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(ApiConfig.uploadDocument),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: filename,
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Gagal upload dokumen: ${response.body}",
      );
    }

    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }
}