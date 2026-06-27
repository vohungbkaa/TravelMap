import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/trips/ui/widgets/trips_screen.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/features/users/ui/view_models/users_view_model.dart';
import 'package:travel_map/shared/base/models/loading_type.dart';
import 'package:travel_map/shared/base/models/paging_param.dart';
import 'package:travel_map/shared/base/widgets/base_paging_screen.dart';

class UsersScreen
    extends BasePagingScreen<UsersViewModel, User, DefaultPagingParam> {
  const UsersScreen({super.key});

  static const routeName = 'users';
  static const routePath = '/users';

  @override
  UsersViewModel getViewModel(BuildContext context) =>
      context.read<UsersViewModel>();

  @override
  DefaultPagingParam? getLoadParam(BuildContext context) =>
      DefaultPagingParam(pageSize: 20);

  @override
  LoadingType get loadingType => LoadingType.shimmer;

  @override
  Widget buildShimmerItem(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.black12),
      title: Container(
        height: 16,
        width: 120,
        margin: const EdgeInsets.only(bottom: 4),
        color: Colors.black12,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 12, width: 180, color: Colors.black12),
          const SizedBox(height: 4),
          Container(height: 12, width: 140, color: Colors.black12),
        ],
      ),
      isThreeLine: true,
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('GitHub Users'),
      actions: [
        IconButton(
          tooltip: 'Trips',
          onPressed: () => context.goNamed(TripsScreen.routeName),
          icon: const Icon(Icons.route_outlined),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: () =>
              getViewModel(context).loadData(isPullToRefresh: true),
          icon: const Icon(Icons.sync_outlined),
        ),
      ],
    );
  }

  @override
  Widget buildItem(BuildContext context, User user) {
    final bool hasValidAvatar =
        user.website.startsWith('http://') || user.website.startsWith('https://');

    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            hasValidAvatar ? NetworkImage(user.website) : null,
        child: !hasValidAvatar
            ? Text(user.name.isEmpty ? '?' : user.name[0].toUpperCase())
            : null,
      ),
      title: Text(user.name),
      subtitle: Text('${user.email}\nType: ${user.phone} • City: ${user.city}'),
      isThreeLine: true,
    );
  }
}
