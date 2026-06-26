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
    final viewModel = context.watch<UsersViewModel>();

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
            tooltip: 'Sync from API',
            onPressed: viewModel.syncing ? null : viewModel.refresh.execute,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      body: viewModel.isEmpty
          ? _EmptyView(
              isLoading: viewModel.load.running || viewModel.syncing,
              onRefresh: viewModel.refresh.execute,
            )
          : _UsersList(viewModel: viewModel),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({required this.viewModel});

  final UsersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: viewModel.refresh.execute,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _SyncStatusHeader(viewModel: viewModel),
          ),
          SliverList.builder(
            itemCount: viewModel.users.length,
            itemBuilder: (context, index) {
              return _UserListTile(user: viewModel.users[index]);
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _SyncStatusHeader extends StatelessWidget {
  const _SyncStatusHeader({required this.viewModel});

  final UsersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final syncError = viewModel.syncError;
    final sourceLabel = switch (viewModel.source) {
      UsersDataSource.local => 'Local database',
      UsersDataSource.remote => 'API synced',
    };
    final lastSyncedAt = viewModel.lastSyncedAt;
    final subtitle = syncError != null
        ? 'Sync failed. Showing cached data.'
        : viewModel.syncing
        ? 'Syncing latest users...'
        : lastSyncedAt == null
        ? 'No remote sync yet'
        : 'Last sync ${TimeOfDay.fromDateTime(lastSyncedAt).format(context)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            if (viewModel.syncing) const LinearProgressIndicator(minHeight: 2),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    syncError != null
                        ? Icons.cloud_off_outlined
                        : viewModel.source == UsersDataSource.remote
                        ? Icons.cloud_done_outlined
                        : Icons.storage_outlined,
                    color: syncError != null
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sourceLabel, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 2),
                        Text(subtitle, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text(
                    '${viewModel.users.length}',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name.isEmpty ? '?' : user.name[0]),
      ),
      title: Text(user.name),
      subtitle: Text('${user.email}\n${user.company} • ${user.city}'),
      isThreeLine: true,
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.outline,
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.isLoading,
    required this.onRefresh,
  });

  final bool isLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No local users',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sync once to store users in the local database.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.sync_outlined),
                label: const Text('Sync from API'),
              ),
          ],
        ),
      ),
    );
  }
}
