import 'package:logging/logging.dart';
import 'package:travel_map/features/auth/data/repositories/auth_repository.dart';
import 'package:travel_map/features/auth/data/services/auth_api_service.dart';
import 'package:travel_map/features/auth/domain/models/auth_session.dart';
import 'package:travel_map/shared/result.dart';

class AuthRepositoryServer implements AuthServerRepository {
  AuthRepositoryServer(this._apiService, this._log);

  final AuthApiService _apiService;
  final Logger _log;

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(1);
      return Ok(
        AuthSession(
          accessToken: 'dev-token-${response.id}',
          userId: response.id,
        ),
      );
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to login', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
