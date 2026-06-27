import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/shared/result.dart';

abstract class UserInteractor {
  Future<Result<List<User>>> getLocalUsers();
  Future<Result<List<User>>> syncUsers({int? since, int? perPage});
}
