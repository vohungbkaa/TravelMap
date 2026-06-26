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
    // Lấy viewModel 1 lần duy nhất
    final viewModel = context.read<TripsViewModel>();

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
            tooltip: 'Refresh',
            onPressed: viewModel.fetchTrips,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: viewModel.isLoading,
        builder: (context, isLoading, _) {
          return ValueListenableBuilder<List<Trip>>(
            valueListenable: viewModel.trips,
            builder: (context, trips, _) {
              // Đang tải và chưa có dữ liệu
              if (isLoading && trips.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Tải xong nhưng rỗng
              if (trips.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.route_outlined, size: 48),
                      const SizedBox(height: 16),
                      const Text('Không có dữ liệu chuyến đi'),
                      FilledButton.icon(
                        onPressed: viewModel.fetchTrips,
                        icon: const Icon(Icons.sync),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              // Có dữ liệu
              return RefreshIndicator(
                onRefresh: viewModel.fetchTrips,
                child: ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    final isCompleted = trip.status == TripStatus.completed;
                    final theme = Theme.of(context);
                    
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
