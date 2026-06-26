import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/users/ui/view_models/users_view_model.dart';
import 'package:travel_map/features/users/ui/widgets/users_screen.dart';

List<RouteBase> get usersRoutes {
  return [
    GoRoute(
      path: UsersScreen.routePath,
      name: UsersScreen.routeName,
      builder: (context, state) {
        return Provider(
          create: (context) => UsersViewModel(
            context.read(),
            Logger('Users'),
          ),
          child: const UsersScreen(),
        );
      },
    ),
  ];
}
