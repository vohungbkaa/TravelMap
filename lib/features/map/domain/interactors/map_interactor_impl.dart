import 'package:travel_map/features/map/data/repositories/map_repository.dart';
import 'package:travel_map/features/map/domain/interactors/map_interactor.dart';
import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/shared/result.dart';

class MapInteractorImpl implements MapInteractor {
  MapInteractorImpl(this._serverRepository);

  final MapServerRepository _serverRepository;

  @override
  Future<Result<List<MapPlace>>> getPlaces() {
    return _serverRepository.getPlaces();
  }
}
