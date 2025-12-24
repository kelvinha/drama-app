/// API Endpoints Configuration
/// Centralized endpoint definitions
class ApiEndpoints {
  // Users
  static const String users = '/users';
  static const String userById = '/users/{id}';

  // Posts
  static const String posts = '/posts';
  static const String postById = '/posts/{id}';
  static const String postComments = '/posts/{id}/comments';

  // Comments
  static const String comments = '/comments';

  // Albums
  static const String albums = '/albums';

  // Photos
  static const String photos = '/photos';

  // Todos
  static const String todos = '/todos';

  /// Helper untuk replace path parameters
  /// Example: replaceParams('/users/{id}', {'id': '1'}) => '/users/1'
  static String replaceParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
