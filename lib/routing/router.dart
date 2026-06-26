import 'package:go_router/go_router.dart';
import 'package:travel_map/features/users/ui/widgets/users_screen.dart';
import 'package:travel_map/routing/trips_routes.dart';
import 'package:travel_map/routing/users_routes.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: UsersScreen.routePath,
    routes: [
      ...usersRoutes,
      ...tripsRoutes,
    ],
  );
}
