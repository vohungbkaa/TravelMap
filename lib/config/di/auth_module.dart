import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/config/feature_env.dart';
import 'package:travel_map/features/auth/data/repositories/auth_repository.dart';
import 'package:travel_map/features/auth/data/repositories/auth_repository_server.dart';
import 'package:travel_map/features/auth/data/services/auth_api_service.dart';
import 'package:travel_map/features/auth/domain/interactors/auth_interactor.dart';
import 'package:travel_map/shared/network/api_client_factory.dart';

List<SingleChildWidget> get authModule {
  return [
    Provider(
      create: (context) => AuthApiService(
        context.read<ApiClientFactory>().create(
            baseUrl: FeatureConfig.auth.baseUrl
        ),
      ),
    ),
    Provider(
      create: (context) => AuthRepositoryServer(
        context.read(),
        Logger('Auth'),
      ) as AuthServerRepository,
    ),
    Provider(
      create: (context) => AuthInteractor(
        context.read(),
        context.read(),
      ),
    ),
  ];
}
