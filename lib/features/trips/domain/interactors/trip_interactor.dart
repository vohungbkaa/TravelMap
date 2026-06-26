import 'package:logging/logging.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

abstract class TripInteractor {
  Future<Result<List<Trip>>> getLocalTrips();
  Future<Result<DateTime?>> getLastSyncedAt();
  Future<Result<List<Trip>>> syncTrips();
}

class TripInteractorImpl implements TripInteractor {
  TripInteractorImpl(this._localRepository, this._serverRepository, this._log);

  final TripLocalRepository _localRepository;
  final TripServerRepository _serverRepository;
  final Logger _log;

  @override
  Future<Result<List<Trip>>> getLocalTrips() {
    return _localRepository.getTrips();
  }

  @override
  Future<Result<DateTime?>> getLastSyncedAt() {
    return _localRepository.getLastSyncedAt();
  }

  @override
  Future<Result<List<Trip>>> syncTrips() async {
    final remoteResult = await _serverRepository.getTrips();
    switch (remoteResult) {
      case Error<List<Trip>>():
        return remoteResult;
      case Ok<List<Trip>>():
        final saveResult = await _localRepository.saveTrips(remoteResult.value);
        switch (saveResult) {
          case Error<void>():
            _log.warning('Failed to persist remote trips', saveResult.error);
            return Error(saveResult.error, saveResult.stackTrace);
          case Ok<void>():
            return _localRepository.getTrips();
        }
    }
  }
}
