import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_config.dart';
import '../error/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_data_source.dart';
import 'doh_client_adapter.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return ApiClient(localDataSource: localDataSource);
});

class ApiClient {
  late final Dio _dio;

  ApiClient({required LocalDataSource localDataSource}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.primaryBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    if (!kIsWeb && localDataSource.getDohBypass()) {
      _dio.httpClientAdapter = createDohAdapter();
    }

    _dio.interceptors.add(RetryInterceptor(dio: _dio));
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: false,
        responseHeader: false,
        responseBody: false,
      ));
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      if (e.error is RateLimitException) {
        throw e.error as RateLimitException;
      }
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException();
    }
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final int retryCount = extra['retryCount'] ?? 0;

    bool shouldRetry = _shouldRetry(err);
    bool shouldFallback = _shouldFallback(err) && ApiConfig.fallbackBaseUrl.isNotEmpty;

    if (err.response?.statusCode == 429) {
      return handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: RateLimitException(),
        type: DioExceptionType.badResponse,
      ));
    }

    if (shouldRetry && retryCount < maxRetries) {
      final delay = retryDelays[retryCount];
      await Future.delayed(delay);

      try {
        final options = err.requestOptions.copyWith(
          extra: {...extra, 'retryCount': retryCount + 1},
        );
        
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    } else if (shouldFallback && (extra['fallbackTried'] ?? false) == false) {
      try {
        final options = err.requestOptions.copyWith(
          baseUrl: ApiConfig.fallbackBaseUrl,
          extra: {...extra, 'fallbackTried': true, 'retryCount': 0},
        );
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null && err.response!.statusCode! >= 500);
  }

  bool _shouldFallback(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null && err.response!.statusCode! >= 500);
  }
}
