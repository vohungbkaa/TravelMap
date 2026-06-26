import 'package:logging/logging.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

class TripInteractor {
  TripInteractor({
    required TripLocalRepository localRepository,
    required TripServerRepository serverRepository,
  }) : _localRepository = localRepository,
       _serverRepository = serverRepository;

  final TripLocalRepository _localRepository;
  final TripServerRepository _serverRepository;
  final _log = Logger('TripInteractor');

  Future<Result<List<Trip>>> getLocalTrips() {
    return _localRepository.getTrips();
  }

  Future<Result<DateTime?>> getLastSyncedAt() {
    return _localRepository.getLastSyncedAt();
  }

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
