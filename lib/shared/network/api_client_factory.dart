import 'package:dio/dio.dart';

class ApiClientFactory {
  const ApiClientFactory();

  Dio create({
    required String baseUrl,
    Iterable<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.addAll([
      _JsonHeadersInterceptor(),
      ...interceptors,
    ]);

    return dio;
  }
}

class _JsonHeadersInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }
}
