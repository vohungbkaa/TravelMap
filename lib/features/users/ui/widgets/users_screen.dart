import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/trips/ui/widgets/trips_screen.dart';
import 'package:travel_map/features/users/domain/models/user.dart';
import 'package:travel_map/features/users/ui/view_models/users_view_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  static const routeName = 'users';
  static const routePath = '/users';

  @override
  Widget build(BuildContext context) {
    // Lấy viewModel 1 lần duy nhất, không dùng watch()
    final viewModel = context.read<UsersViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Trips',
            onPressed: () => context.goNamed(TripsScreen.routeName),
            icon: const Icon(Icons.route_outlined),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: viewModel.fetchUsers,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: viewModel.isLoading,
        builder: (context, isLoading, _) {
          return ValueListenableBuilder<List<User>>(
            valueListenable: viewModel.users,
            builder: (context, users, _) {
              // Đang tải và chưa có dữ liệu
              if (isLoading && users.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Tải xong nhưng rỗng
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_outline, size: 48),
                      const SizedBox(height: 16),
                      const Text('Không có dữ liệu'),
                      FilledButton.icon(
                        onPressed: viewModel.fetchUsers,
                        icon: const Icon(Icons.sync),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              // Có dữ liệu
              return RefreshIndicator(
                onRefresh: viewModel.fetchUsers,
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.name.isEmpty ? '?' : user.name[0]),
                      ),
                      title: Text(user.name),
                      subtitle: Text('${user.email}\n${user.company} • ${user.city}'),
                      isThreeLine: true,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
