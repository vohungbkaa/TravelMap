import 'package:logging/logging.dart';
import 'package:travel_map/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_map/features/trips/data/services/trip_api_service.dart';
import 'package:travel_map/features/trips/domain/models/trip.dart';
import 'package:travel_map/shared/result.dart';

class TripRepositoryServer implements TripServerRepository {
  TripRepositoryServer({required TripApiService apiService})
    : _apiService = apiService;

  final TripApiService _apiService;
  final _log = Logger('TripRepositoryServer');

  @override
  Future<Result<List<Trip>>> getTrips() async {
    try {
      return Ok(await _apiService.getTrips());
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load remote trips', error, stackTrace);
      return Error(error, stackTrace);
    }
  }
}
