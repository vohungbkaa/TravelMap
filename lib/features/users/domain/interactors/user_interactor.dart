import 'package:logging/logging.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UserInteractor {
  UserInteractor({
    required UserLocalRepository localRepository,
    required UserServerRepository serverRepository,
  }) : _localRepository = localRepository,
       _serverRepository = serverRepository;

  final UserLocalRepository _localRepository;
  final UserServerRepository _serverRepository;
  final _log = Logger('UserInteractor');

  Future<Result<List<User>>> getLocalUsers() {
    return _localRepository.getUsers();
  }

  Future<Result<DateTime?>> getLastSyncedAt() {
    return _localRepository.getLastSyncedAt();
  }

  Future<Result<List<User>>> syncUsers() async {
    final remoteResult = await _serverRepository.getUsers();
    switch (remoteResult) {
      case Error<List<User>>():
        return remoteResult;
      case Ok<List<User>>():
        final saveResult = await _localRepository.saveUsers(remoteResult.value);
        switch (saveResult) {
          case Error<void>():
            _log.warning('Failed to persist remote users', saveResult.error);
            return Error(saveResult.error, saveResult.stackTrace);
          case Ok<void>():
            return _localRepository.getUsers();
        }
    }
  }
}
