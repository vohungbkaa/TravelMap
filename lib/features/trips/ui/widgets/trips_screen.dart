import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/features/trips/ui/view_models/trips_view_model.dart';
import 'package:travel_map/features/users/ui/widgets/users_screen.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  static const routeName = 'trips';
  static const routePath = '/trips';

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        actions: [
          IconButton(
            tooltip: 'Users',
            onPressed: () => context.goNamed(UsersScreen.routeName),
            icon: const Icon(Icons.people_outline),
          ),
          IconButton(
            tooltip: 'Sync trips',
            onPressed: viewModel.syncing ? null : viewModel.refresh.execute,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      body: viewModel.isEmpty
          ? _EmptyTripsView(
              isLoading: viewModel.load.running || viewModel.syncing,
              onRefresh: viewModel.refresh.execute,
            )
          : _TripsList(viewModel: viewModel),
    );
  }
}

class _TripsList extends StatelessWidget {
  const _TripsList({required this.viewModel});

  final TripsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: viewModel.refresh.execute,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _TripSyncHeader(viewModel: viewModel)),
          SliverList.builder(
            itemCount: viewModel.trips.length,
            itemBuilder: (context, index) {
              return _TripListTile(trip: viewModel.trips[index]);
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _TripSyncHeader extends StatelessWidget {
  const _TripSyncHeader({required this.viewModel});

  final TripsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final syncError = viewModel.syncError;
    final sourceLabel = switch (viewModel.source) {
      TripsDataSource.local => 'Local database',
      TripsDataSource.remote => 'API synced',
    };
    final lastSyncedAt = viewModel.lastSyncedAt;
    final subtitle = syncError != null
        ? 'Sync failed. Showing cached trips.'
        : viewModel.syncing
        ? 'Syncing latest trips...'
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
                        : viewModel.source == TripsDataSource.remote
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
                    '${viewModel.trips.length}',
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

class _TripListTile extends StatelessWidget {
  const _TripListTile({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = trip.status == TripStatus.completed;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted
            ? theme.colorScheme.tertiaryContainer
            : theme.colorScheme.primaryContainer,
        child: Icon(
          isCompleted ? Icons.check_outlined : Icons.route_outlined,
          color: isCompleted
              ? theme.colorScheme.onTertiaryContainer
              : theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(trip.title),
      subtitle: Text('Owner user #${trip.ownerUserId}'),
      trailing: Text(
        isCompleted ? 'Done' : 'Planned',
        style: theme.textTheme.labelMedium,
      ),
    );
  }
}

class _EmptyTripsView extends StatelessWidget {
  const _EmptyTripsView({
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
              Icons.route_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No local trips',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sync once to store trips in the local database.',
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
                label: const Text('Sync trips'),
              ),
          ],
        ),
      ),
    );
  }
}
