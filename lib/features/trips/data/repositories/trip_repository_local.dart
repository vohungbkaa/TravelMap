import 'package:logging/logging.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/data/services/trip_local_service.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

class TripRepositoryLocal implements TripLocalRepository {
  TripRepositoryLocal(this._localService, this._log);

  final TripLocalService _localService;
  final Logger _log;

  @override
  Future<Result<List<Trip>>> getTrips() async {
    try {
      return Ok(await _localService.getTrips());
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load local trips', error, stackTrace);
      return Error(error, stackTrace);
    }
  }

  @override
  Future<Result<DateTime?>> getLastSyncedAt() async {
    try {
      return Ok(await _localService.getLastSyncedAt());
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load trip sync time', error, stackTrace);
      return Error(error, stackTrace);
    }
  }

  @override
  Future<Result<void>> saveTrips(List<Trip> trips) async {
    try {
      await _localService.upsertTrips(trips);
      return const Ok(null);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to save local trips', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
