import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📤 REQUEST: ${options.method} ${options.uri}');
    print('📤 Headers: ${options.headers}');
    if (options.data != null) {
      print('📤 Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    print('✅ Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.type} ${err.message}');
    if (err.response != null) {
      print('❌ Response: ${err.response?.statusCode} ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
