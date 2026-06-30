import 'package:go_router/go_router.dart';
import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/features/map/ui/widgets/map_screen.dart';
import 'package:travel_map/features/map/ui/widgets/place_detail_screen.dart';
import 'package:travel_map/features/news/ui/widgets/news_screen.dart';
import 'package:travel_map/features/shop/ui/widgets/shop_screen.dart';
import 'package:travel_map/routing/main_shell.dart';
import 'package:travel_map/routing/trips_routes.dart';
import 'package:travel_map/routing/users_routes.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: NewsScreen.routePath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: NewsScreen.routePath,
                name: NewsScreen.routeName,
                builder: (context, state) => const NewsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ShopScreen.routePath,
                name: ShopScreen.routeName,
                builder: (context, state) => const ShopScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MapScreen.routePath,
                name: MapScreen.routeName,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: PlaceDetailScreen.routePath,
        name: PlaceDetailScreen.routeName,
        builder: (context, state) {
          final place = state.extra as MapPlace;
          return PlaceDetailScreen(place: place);
        },
      ),
      ...usersRoutes,
      ...tripsRoutes,
    ],
  );
}
