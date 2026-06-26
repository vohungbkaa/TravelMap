import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository_local.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository_server.dart';
import 'package:travel_map/features/trips/data/services/trip_api_service.dart';
import 'package:travel_map/features/trips/data/services/trip_local_service.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/features/users/data/repositories/user_repository.dart';
import 'package:travel_map/features/users/data/repositories/user_repository_local.dart';
import 'package:travel_map/features/users/data/repositories/user_repository_server.dart';
import 'package:travel_map/features/users/data/services/user_api_service.dart';
import 'package:travel_map/features/users/data/services/user_local_service.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/shared/app_database.dart';

List<SingleChildWidget> get providersDevelopment {
  return [
    Provider(
      create: (context) => Dio(
        BaseOptions(
          baseUrl: 'https://jsonplaceholder.typicode.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      ),
    ),
    Provider(
      create: (context) => AppDatabase(),
      dispose: (context, database) => database.close(),
    ),
    Provider(create: (context) => UserApiService(dio: context.read())),
    Provider(create: (context) => TripApiService(dio: context.read())),
    Provider(create: (context) => UserLocalService(database: context.read())),
    Provider(create: (context) => TripLocalService(database: context.read())),
    Provider(
      create: (context) =>
          UserRepositoryLocal(
                localService: context.read(),
              )
              as UserLocalRepository,
    ),
    Provider(
      create: (context) =>
          UserRepositoryServer(apiService: context.read())
              as UserServerRepository,
    ),
    Provider(
      create: (context) => UserInteractor(
        localRepository: context.read(),
        serverRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) =>
          TripRepositoryLocal(
                localService: context.read(),
              )
              as TripLocalRepository,
    ),
    Provider(
      create: (context) =>
          TripRepositoryServer(apiService: context.read())
              as TripServerRepository,
    ),
    Provider(
      create: (context) => TripInteractor(
        localRepository: context.read(),
        serverRepository: context.read(),
      ),
    ),
  ];
}
