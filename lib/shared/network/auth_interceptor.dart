import 'package:dio/dio.dart';
import 'package:travel_map/shared/network/auth_token_provider.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required AuthTokenProvider tokenProvider})
    : _tokenProvider = tokenProvider;

  final AuthTokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenProvider.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
