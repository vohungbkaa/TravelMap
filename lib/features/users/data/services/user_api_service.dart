import 'package:dio/dio.dart';
import 'package:travel_map/features/users/domain/models/user.dart';

class UserApiService {
  const UserApiService({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<User>> getUsers() async {
    final response = await _dio.get<List<dynamic>>('/users');
    final data = response.data ?? [];

    return [
      for (final item in data)
        User.fromApiJson(Map<String, dynamic>.from(item as Map)),
    ];
  }
}
