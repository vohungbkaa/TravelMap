import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

abstract class TripInteractor {
  Future<Result<List<Trip>>> getLocalTrips();
  Future<Result<List<Trip>>> syncTrips();
}

