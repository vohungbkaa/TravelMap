import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

abstract interface class TripLocalRepository {
  Future<Result<List<Trip>>> getTrips();

  Future<Result<void>> saveTrips(List<Trip> trips);

  Future<Result<DateTime?>> getLastSyncedAt();
}

abstract interface class TripServerRepository {
  Future<Result<List<Trip>>> getTrips();
}
