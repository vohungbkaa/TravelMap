import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/config/feature_env.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/data/repositories/user_repository_local.dart';
import 'package:travel_map/features/users/data/repositories/user_repository_server.dart';
import 'package:travel_map/features/users/data/services/user_api_service.dart';
import 'package:travel_map/features/users/data/services/user_local_service.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/shared/network/api_client_factory.dart';
import 'package:travel_map/shared/network/auth_interceptor.dart';

List<SingleChildWidget> get usersModule {
  return [
    Provider(
      create: (context) => UserApiService(
        context.read<ApiClientFactory>().create(
          baseUrl: FeatureConfig.user.baseUrl,
          interceptors: [context.read<AuthInterceptor>()],
        ),
      ),
    ),
    Provider(create: (context) => UserLocalService(database: context.read())),
    Provider(
      create: (context) => UserRepositoryLocal(
        context.read(),
        context.read<Logger>(),
      ) as UserLocalRepository,
    ),
    Provider(
      create: (context) => UserRepositoryServer(
        context.read(),
        context.read<Logger>(),
      ) as UserServerRepository,
    ),
    Provider(
      create: (context) => UserInteractor(
        context.read(),
        context.read(),
        context.read<Logger>(),
      ),
    ),
  ];
}
