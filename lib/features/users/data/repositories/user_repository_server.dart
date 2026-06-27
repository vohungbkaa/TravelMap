import 'package:logging/logging.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/data/services/user_api_service.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UserServerRepositoryImpl implements UserServerRepository {
  UserServerRepositoryImpl(this._apiService, this._log);

  final UserApiService _apiService;
  final Logger _log;

  @override
  Future<Result<List<User>>> getUsers({int? since, int? perPage}) async {
    try {
      final data = await _apiService.getUsers(since: since, perPage: perPage);
      return Ok(data);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load remote users', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
