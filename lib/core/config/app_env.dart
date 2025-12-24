/// Environment Configuration
/// Konfigurasi untuk berbagai environment (development, staging, production)
///
/// Usage:
/// ```dart
/// final apiUrl = AppEnv.apiBaseUrl;
/// final apiKey = AppEnv.apiKey;
/// ```
enum Environment { development, staging, production }

class AppEnv {
  static Environment _currentEnv = Environment.development;

  /// Set environment saat app start
  static void setEnvironment(Environment env) {
    _currentEnv = env;
  }

  static Environment get currentEnv => _currentEnv;

  /// API Base URL
  static String get apiBaseUrl {
    switch (_currentEnv) {
      case Environment.development:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://jsonplaceholder.typicode.com',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://staging-api.example.com',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.example.com',
        );
    }
  }

  /// API Key (jika diperlukan)
  static String get apiKey {
    return const String.fromEnvironment('API_KEY', defaultValue: '');
  }

  /// API Secret (jika diperlukan)
  static String get apiSecret {
    return const String.fromEnvironment('API_SECRET', defaultValue: '');
  }

  /// Debug mode
  static bool get isDebugMode {
    return _currentEnv == Environment.development;
  }

  /// Timeout durations (milliseconds)
  static int get connectionTimeout {
    return const int.fromEnvironment('CONNECTION_TIMEOUT', defaultValue: 30000);
  }

  static int get receiveTimeout {
    return const int.fromEnvironment('RECEIVE_TIMEOUT', defaultValue: 30000);
  }
}
