import 'package:dio/dio.dart';

/// Custom API Interceptor
/// Untuk logging request dan response serta error handling

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log request
    print('┌─────────────────────────────────────────────────────────');
    print('│ 🚀 REQUEST');
    print('│ ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      print('│ Headers: ${options.headers}');
    }
    if (options.data != null) {
      print('│ Body: ${options.data}');
    }
    print('└─────────────────────────────────────────────────────────');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response
    print('┌─────────────────────────────────────────────────────────');
    print('│ ✅ RESPONSE');
    print('│ ${response.statusCode} ${response.requestOptions.uri}');
    print(
      '│ Data: ${response.data.toString().substring(0, response.data.toString().length > 200 ? 200 : response.data.toString().length)}...',
    );
    print('└─────────────────────────────────────────────────────────');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error
    print('┌─────────────────────────────────────────────────────────');
    print('│ ❌ ERROR');
    print('│ ${err.type}');
    print('│ ${err.message}');
    if (err.response != null) {
      print('│ Status: ${err.response?.statusCode}');
      print('│ Data: ${err.response?.data}');
    }
    print('└─────────────────────────────────────────────────────────');

    handler.next(err);
  }
}
