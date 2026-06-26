import 'dart:async';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor_impl.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/features/trips/ui/view_models/trips_view_model.dart';
import 'package:travel_map/features/trips/ui/widgets/trips_screen.dart';
import 'package:travel_map/shared/result.dart';

void main() {
  testWidgets('shows cached trips before remote trips', (tester) async {
    final localRepository = _FakeTripLocalRepository();
    final serverRepository = _FakeTripServerRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Provider(
          create: (context) => TripsViewModel(
            TripInteractorImpl(localRepository, serverRepository),
            Logger('Test'),
          ),
          child: const TripsScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Trips'), findsOneWidget);
    expect(find.text('Cached Trip'), findsOneWidget);

    serverRepository.completeRemoteSync();
    await tester.pumpAndSettle();

    expect(find.text('Remote Trip'), findsOneWidget);
  });
}

class _FakeTripLocalRepository implements TripLocalRepository {
  List<Trip> _trips = const [
    Trip(
      id: 1,
      title: 'Cached Trip',
      ownerUserId: 1,
      status: TripStatus.planned,
    ),
  ];

  @override
  Future<Result<List<Trip>>> getTrips() async {
    return Ok(_trips);
  }

  @override
  Future<Result<DateTime?>> getLastSyncedAt() async {
    return const Ok(null);
  }

  @override
  Future<Result<void>> saveTrips(List<Trip> trips) async {
    _trips = trips;
    return const Ok(null);
  }
}

class _FakeTripServerRepository implements TripServerRepository {
  final Completer<Result<List<Trip>>> _remoteSyncCompleter =
      Completer<Result<List<Trip>>>();

  @override
  Future<Result<List<Trip>>> getTrips() {
    return _remoteSyncCompleter.future;
  }

  void completeRemoteSync() {
    _remoteSyncCompleter.complete(
      const Ok([
        Trip(
          id: 1,
          title: 'Remote Trip',
          ownerUserId: 2,
          status: TripStatus.completed,
        ),
      ]),
    );
  }
}
