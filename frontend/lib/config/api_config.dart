import 'package:flutter_dotenv/flutter_dotenv.dart';
class ApiConfig {
  static String get baseUrl =>
    dotenv.env['BASE_URL'] ?? "https://default-url.com";

  static String get chat =>
      "$baseUrl/chat";

  static String get uploadDocument =>
      "$baseUrl/documents/Upload";
}

