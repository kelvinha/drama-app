import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import '../config/app_env.dart';
import 'api_interceptor.dart';

/// Dio Client
/// Konfigurasi Dio dengan Chucker interceptor
/// Menggunakan AppEnv untuk konfigurasi

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppEnv.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppEnv.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Tambahkan API Key jika ada
          if (AppEnv.apiKey.isNotEmpty) 'X-API-Key': AppEnv.apiKey,
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      // Chucker interceptor untuk monitoring HTTP requests
      ChuckerDioInterceptor(),
      // Custom logging interceptor (hanya di debug mode)
      if (AppEnv.isDebugMode) ApiInterceptor(),
    ]);
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
