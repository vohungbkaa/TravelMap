import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/shared/result.dart';

abstract class MapInteractor {
  Future<Result<List<MapPlace>>> getPlaces();
}
