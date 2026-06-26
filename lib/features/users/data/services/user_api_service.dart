import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:travel_map/features/users/domain/models/user.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio) = _UserApiService;

  @GET('/users')
  Future<List<User>> getUsers();

  @GET('/users/{id}')
  Future<User> getUserById(@Path('id') int userId);

  @GET('/users')
  Future<List<User>> getUsersByRole(@Query('role') String role);
}
