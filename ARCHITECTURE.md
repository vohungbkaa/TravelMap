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
