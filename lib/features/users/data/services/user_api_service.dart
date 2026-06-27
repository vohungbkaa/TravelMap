import 'package:dio/dio.dart';
import 'package:travel_map/features/users/domain/models/user.dart';

class UserApiService {
  const UserApiService(this._dio);
  final Dio _dio;

  Future<List<User>> getUsers({int? since, int? perPage}) async {
    final response = await _dio.get(
      'https://api.github.com/users',
      queryParameters: {
        if (since != null) 'since': since,
        if (perPage != null) 'per_page': perPage,
      },
    );
    
    final list = response.data as List;
    return list.map((json) => User.fromApiJson(json as Map<String, dynamic>)).toList();
  }

  Future<User> getUserById(int userId) async {
    final response = await _dio.get('https://api.github.com/user/$userId');
    return User.fromApiJson(response.data as Map<String, dynamic>);
  }
}
