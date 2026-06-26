import 'package:travel_map/features/auth/data/repositories/auth_repository.dart';
import 'package:travel_map/features/auth/domain/models/auth_session.dart';
import 'package:travel_map/shared/network/auth_token_provider.dart';
import 'package:travel_map/shared/result.dart';

abstract class AuthInteractor {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });
}

