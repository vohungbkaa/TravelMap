import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/config/feature_env.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository_local.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository_server.dart';
import 'package:travel_map/features/trips/data/services/trip_api_service.dart';
import 'package:travel_map/features/trips/data/services/trip_local_service.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/shared/network/api_client_factory.dart';
import 'package:travel_map/shared/network/auth_interceptor.dart';

List<SingleChildWidget> get tripsModule {
  return [
    Provider(
      create: (context) => TripApiService(
        context.read<ApiClientFactory>().create(
          baseUrl: FeatureConfig.trip.baseUrl,
          interceptors: [context.read<AuthInterceptor>()],
        ),
      ),
    ),
    Provider(create: (context) => TripLocalService(database: context.read())),
    Provider<TripLocalRepository>(
      create: (context) => TripLocalRepositoryImpl(
        context.read(),
        Logger('Trips'),
      ),
    ),
    Provider<TripServerRepository>(
      create: (context) => TripServerRepositoryImpl(
        context.read(),
        Logger('Trips'),
      ),
    ),
    Provider<TripInteractor>(
      create: (context) => TripInteractorImpl(
        context.read(),
        context.read(),
      ),
    ),
  ];
}
