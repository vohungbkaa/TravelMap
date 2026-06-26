import 'package:logging/logging.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/data/services/user_api_service.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UserRepositoryServer implements UserServerRepository {
  UserRepositoryServer({required UserApiService apiService})
    : _apiService = apiService;

  final UserApiService _apiService;
  final _log = Logger('UserRepositoryServer');

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      return Ok(await _apiService.getUsers());
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load remote users', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
