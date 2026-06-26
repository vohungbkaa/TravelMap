import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/users/domain/interactors/user_interactor.dart';
import 'package:travel_map/features/users/ui/view_models/users_view_model.dart';
import 'package:travel_map/features/users/ui/widgets/users_screen.dart';

List<RouteBase> get usersRoutes {
  return [
    GoRoute(
      path: UsersScreen.routePath,
      name: UsersScreen.routeName,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (context) => UsersViewModel(
            userInteractor: context.read<UserInteractor>(),
          ),
          child: const UsersScreen(),
        );
      },
    ),
  ];
}
