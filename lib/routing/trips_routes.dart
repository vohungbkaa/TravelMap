import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/features/trips/ui/view_models/trips_view_model.dart';
import 'package:travel_map/features/trips/ui/widgets/trips_screen.dart';

List<RouteBase> get tripsRoutes {
  return [
    GoRoute(
      path: TripsScreen.routePath,
      name: TripsScreen.routeName,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (context) => TripsViewModel(
            context.read(),
            context.read<Logger>(),
          ),
          child: const TripsScreen(),
        );
      },
    ),
  ];
}
