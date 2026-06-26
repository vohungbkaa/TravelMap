import 'package:travel_map/features/auth/domain/models/auth_session.dart';
import 'package:travel_map/shared/result.dart';

abstract interface class AuthServerRepository {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });
}
