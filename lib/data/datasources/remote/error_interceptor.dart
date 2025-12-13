import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final dynamic data;

  NetworkException(this.message, [this.data]);

  @override
  String toString() => message;
}

class TimeoutException extends NetworkException {
  TimeoutException() : super('Превышено время ожидания запроса');
}

class BadRequestException extends NetworkException {
  BadRequestException(dynamic data) : super('Некорректный запрос', data);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException() : super('Необходима авторизация');
}

class ServerException extends NetworkException {
  ServerException() : super('Ошибка сервера');
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException();
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.response?.data);
          case 401:
            throw UnauthorizedException();
          case 500:
          case 502:
          case 503:
            throw ServerException();
          default:
            throw NetworkException('Неизвестная ошибка: ${err.response?.statusCode}');
        }
      case DioExceptionType.cancel:
        throw NetworkException('Запрос отменен');
      default:
        throw NetworkException('Ошибка сети: ${err.message}');
    }
  }
}
