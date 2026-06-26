import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:travel_map/features/auth/data/services/auth_user_response.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @GET('/users/{id}')
  Future<AuthUserResponse> login(@Path('id') int userId);
}
