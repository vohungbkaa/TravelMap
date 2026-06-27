import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

abstract interface class UserLocalRepository {
  Future<Result<List<User>>> getUsers();

  Future<Result<void>> saveUsers(List<User> users);

  Future<Result<DateTime?>> getLastSyncedAt();
}

abstract interface class UserServerRepository {
  Future<Result<List<User>>> getUsers({int? since, int? perPage});
}
