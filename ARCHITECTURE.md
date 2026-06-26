# Architecture

This project follows the Flutter architecture guide and mirrors the Compass app
sample principles, with feature-first folders for scale:

```txt
lib/
  config/          dependency graph for each app configuration
  features/
    users/
      data/        repositories and services for users
      domain/      user models and interactors/business use cases
      ui/          user screens, widgets, and view models
    trips/
      data/        repositories and services for trips
      domain/      trip models and interactors/business use cases
      ui/          trip screens, widgets, and view models
  routing/         feature route registration
  shared/          app database, Result, Command, and other cross-feature code
```

## API Modules

The API setup uses `retrofit.dart` and follows the same idea as Kotlin Retrofit
modules:

```txt
shared/network/api_client_factory.dart    common Dio builder and interceptors
features/users/data/services/             UserApiService with @GET/@Path/@Query
features/trips/data/services/             TripApiService with @GET/@Path/@Query
features/auth/data/services/              AuthApiService with @GET/@Path/@Query
config/dependencies.dart                  composes base API and feature APIs
config/feature_env.dart                   per-feature test/release base URLs
config/di/base_module.dart                shared network/database providers
config/di/auth_module.dart                auth providers
config/di/users_module.dart               users providers
config/di/trips_module.dart               trips providers
```

Each feature DI module owns its base URL through `FeatureEnv`:

```dart
const _userEnv = FeatureUserEnv(
  testUrl: 'https://test-user-service.example.com',
  releaseUrl: 'https://user-service.example.com',
);

Provider(
  create: (context) => UserApiService(
    context.read<ApiClientFactory>().create(baseUrl: _userEnv.getBaseUrl()),
  ),
);
```

Two services may share a base URL or use different base URLs. The app does not
use one global Dio instance. Each API service receives its own Dio built by
`ApiClientFactory`, similar to creating a Retrofit instance per module.

`FeatureEnv.currentEnv` defaults to `EnvConfig.release`. For now every feature
uses `BASE_URL_DEFAULT`, and individual feature URLs can be overridden later.

API service files stay close to Kotlin Retrofit interfaces: they only describe
endpoints with `@GET`, `@Path`, `@Query`, and return types.

Generated Retrofit implementations live next to their service declarations as
`*.g.dart` files. Regenerate them after changing an API interface:

```sh
dart run build_runner build
```

## Data Flow

Screens do not call APIs or databases directly.

```txt
Screen -> ViewModel -> Interactor -> Local repository -> Local service
                              -> Server repository -> API service
```

ViewModels load local data first, notify the UI, then sync remote data in the
background. Interactors own the business flow: read local data, request remote
data, persist it locally, then return the latest local state to the ViewModel.
Repositories stay narrow: local repositories only talk to SQLite services, and
server repositories only talk to API services.

## Adding A Module

The `trips` module mirrors the `users` module:

```txt
features/trips/
  data/
    repositories/
    services/
  domain/
    interactors/
    models/
  ui/
    view_models/
    widgets/
routing/trips_routes.dart
```

To add a new feature:

1. Add a folder in `features/<feature>/`.
2. Add domain models in `features/<feature>/domain/models/`.
3. Add local/API services in `features/<feature>/data/services/`.
4. Add local/server repository contracts and implementations in
   `features/<feature>/data/repositories/`.
5. Add an interactor in `features/<feature>/domain/interactors/`.
6. Add ViewModel and screen in `features/<feature>/ui/`.
7. Add `<feature>_routes.dart` and compose it in `routing/router.dart`.
8. Register dependencies in `config/dependencies.dart`.
