import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/domain/interactors/trip_interactor.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

class TripInteractorImpl implements TripInteractor {
  TripInteractorImpl(this._localRepository, this._serverRepository);

  final TripLocalRepository _localRepository;
  final TripServerRepository _serverRepository;

  @override
  Future<Result<List<Trip>>> getLocalTrips() {
    return _localRepository.getTrips();
  }

  @override
  Future<Result<List<Trip>>> syncTrips() async {
    final remoteResult = await _serverRepository.getTrips();
    if (remoteResult is Ok<List<Trip>>) {
      await _localRepository.saveTrips(remoteResult.value);
      return _localRepository.getTrips();
    }
    return remoteResult;
  }
}
