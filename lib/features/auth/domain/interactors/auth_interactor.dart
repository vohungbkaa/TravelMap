import 'package:travel_map/features/auth/data/repositories/auth_repository.dart';
import 'package:travel_map/features/auth/domain/models/auth_session.dart';
import 'package:travel_map/shared/network/auth_token_provider.dart';
import 'package:travel_map/shared/result.dart';

abstract class AuthInteractor {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });
}

class AuthInteractorImpl implements AuthInteractor {
  AuthInteractorImpl(this._serverRepository, this._tokenProvider);

  final AuthServerRepository _serverRepository;
  final InMemoryAuthTokenProvider _tokenProvider;

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    final result = await _serverRepository.login(
      username: username,
      password: password,
    );

    switch (result) {
      case Ok<AuthSession>():
        _tokenProvider.accessToken.value = result.value.accessToken;
      case Error<AuthSession>():
    }

    return result;
  }
}
