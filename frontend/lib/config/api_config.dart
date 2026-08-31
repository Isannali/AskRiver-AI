class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static String get chat => '$baseUrl/chat';

  static String get uploadDocument => '$baseUrl/documents/Upload';
}