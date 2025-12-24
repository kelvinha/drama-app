/// API Constants
/// Konstanta untuk base URL dan endpoints
class ApiConstants {
  // Base URL - JSONPlaceholder (Dummy API)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Endpoints
  static const String users = '/users';
  static const String posts = '/posts';
  static const String comments = '/comments';

  // Timeout durations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
