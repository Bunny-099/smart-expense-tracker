import 'package:dio/dio.dart';
import 'network_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl})
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        int retries = 2,
      }) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await _dio.get(
          endpoint,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
        return response.data;
      } on DioException catch (e) {
        attempt++;
        if (attempt > retries || _isNotRetryable(e)) {
          throw NetworkException.fromDioException(e);
        }
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      } catch (e) {
        throw NetworkException(message: e.toString());
      }
    }
  }

  bool _isNotRetryable(DioException exception) {
    return exception.type == DioExceptionType.badResponse ||
        exception.type == DioExceptionType.cancel;
  }
}