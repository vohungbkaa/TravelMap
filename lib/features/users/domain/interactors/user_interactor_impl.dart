import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

class UserInteractorImpl implements UserInteractor {
  UserInteractorImpl(this._localRepository, this._serverRepository);

  final UserLocalRepository _localRepository;
  final UserServerRepository _serverRepository;

  @override
  Future<Result<List<User>>> getLocalUsers() {
    return _localRepository.getUsers();
  }

  @override
  Future<Result<List<User>>> syncUsers({int? since, int? perPage}) async {
    final remoteResult = await _serverRepository.getUsers(since: since, perPage: perPage);
    if (remoteResult is Ok<List<User>>) {
      await _localRepository.saveUsers(remoteResult.value);
      // Đọc lại từ DB để đảm bảo luồng SSOT (Single Source of Truth)
      return _localRepository.getUsers();
    }
    return remoteResult;
  }
}
