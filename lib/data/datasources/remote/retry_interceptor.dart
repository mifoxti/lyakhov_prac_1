import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on network errors or server errors, not on client errors (4xx)
    if (_shouldRetry(err)) {
      for (int i = 0; i < maxRetries; i++) {
        try {
          print('🔄 Retrying request (${i + 1}/$maxRetries): ${err.requestOptions.uri}');
          await Future.delayed(retryDelay);

          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          print('❌ Retry ${i + 1} failed: $e');
          if (i == maxRetries - 1) {
            // Last retry failed, continue with original error
            break;
          }
        }
      }
    }

    // If we shouldn't retry or all retries failed, continue with original error
    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    // Retry on network errors, timeouts, and server errors (5xx)
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
