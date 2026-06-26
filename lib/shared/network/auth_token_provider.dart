import 'package:flutter/foundation.dart';

abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
}

class InMemoryAuthTokenProvider implements AuthTokenProvider {
  final ValueNotifier<String?> accessToken = ValueNotifier(null);

  @override
  Future<String?> getAccessToken() async {
    return accessToken.value;
  }
}
