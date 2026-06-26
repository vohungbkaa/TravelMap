import 'package:logging/logging.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

abstract class UserInteractor {
  Future<Result<List<User>>> getListUser();
}

class UserInteractorImpl implements UserInteractor {
  UserInteractorImpl(this._localRepository, this._serverRepository, this._log);

  final UserLocalRepository _localRepository;
  final UserServerRepository _serverRepository;
  final Logger _log;

  @override
  Future<Result<List<User>>> getListUser() async {
    // Ưu tiên gọi API trước
    final remoteResult = await _serverRepository.getUsers();
    if (remoteResult is Ok<List<User>>) {
      // Lưu vào cache
      await _localRepository.saveUsers(remoteResult.value);
      return remoteResult;
    }
    
    _log.warning('Lỗi gọi API, lấy dữ liệu từ local cache');
    // Fallback về Local
    return _localRepository.getUsers();
  }
}
