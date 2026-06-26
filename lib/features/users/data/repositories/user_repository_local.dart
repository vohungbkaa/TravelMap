import 'package:logging/logging.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/data/services/user_local_service.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UserRepositoryLocal implements UserLocalRepository {
  UserRepositoryLocal(this._localService, this._log);

  final UserLocalService _localService;
  final Logger _log;

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      return Ok(await _localService.getUsers());
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load local users', error, stackTrace);
      return Error(error, stackTrace);
    }
  }

  @override
  Future<Result<DateTime?>> getLastSyncedAt() async {
    try {
      return Ok(await _localService.getLastSyncedAt());
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load user sync time', error, stackTrace);
      return Error(error, stackTrace);
    }
  }

  @override
  Future<Result<void>> saveUsers(List<User> users) async {
    try {
      await _localService.upsertUsers(users);
      return const Ok(null);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to save local users', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
