import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({
    required this.message,
    this.statusCode,
  });

  factory NetworkException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timed out. Please try again.',
          statusCode: exception.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(
          exception.response?.statusCode,
          exception.response?.data,
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badCertificate:
        return NetworkException(message: 'Bad SSL certificate.');
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }

  static NetworkException _handleBadResponse(int? statusCode, dynamic data) {
    String message = 'Something went wrong.';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'];
    } else if (statusCode != null) {
      switch (statusCode) {
        case 400:
          message = 'Bad request.';
          break;
        case 401:
        case 403:
          message = 'Unauthorized access.';
          break;
        case 404:
          message = 'Requested resource not found.';
          break;
        case 500:
        case 502:
        case 503:
          message = 'Internal server error. Please try later.';
          break;
        default:
          message = 'Received error status code: $statusCode';
      }
    }
    return NetworkException(message: message, statusCode: statusCode);
  }

  @override
  String toString() => message;
}