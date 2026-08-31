class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static String get chat => '$baseUrl/api/v1/chat';

  static String get uploadDocument => '$baseUrl/api/v1/documents/Upload';
}