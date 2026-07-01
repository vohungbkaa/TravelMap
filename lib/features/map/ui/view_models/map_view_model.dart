import 'package:flutter/foundation.dart';
import 'package:travel_map/features/map/domain/interactors/map_interactor.dart';
import 'package:travel_map/features/map/domain/models/map_category.dart';
import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/shared/base/viewmodels/base_api_view_model.dart';
import 'package:travel_map/shared/result.dart';

class MapViewModel extends BaseApiViewModel<List<MapPlace>, void>
    with ChangeNotifier {
  MapViewModel(this._mapInteractor);

  final MapInteractor _mapInteractor;

  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;

  double? _selectedMaxDistance;
  double? get selectedMaxDistance => _selectedMaxDistance;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  MapPlace? _selectedPlace;
  MapPlace? get selectedPlace => _selectedPlace;

  String _mapStyle = 'voyager';
  String get mapStyle => _mapStyle;

  String get tileUrlTemplate {
    switch (_mapStyle) {
      case 'positron':
        return 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
      case 'dark':
        return 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
      case 'standard':
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case 'voyager':
      default:
        return 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
    }
  }

  void setMapStyle(String style) {
    if (_mapStyle != style) {
      _mapStyle = style;
      notifyListeners();
    }
  }

  List<MapPlace> get filteredPlaces {
    final places = response.value ?? [];
    return places.where((place) {
      final matchesCat =
          _selectedCategory == 'all' || place.category == _selectedCategory;
      final matchesDist = _selectedMaxDistance == null ||
          place.distanceKm <= _selectedMaxDistance!;
      final queryLower = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          place.title.toLowerCase().contains(queryLower) ||
          place.address.toLowerCase().contains(queryLower);
      return matchesCat && matchesDist && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setDistanceFilter(double? maxDistance) {
    if (_selectedMaxDistance != maxDistance) {
      _selectedMaxDistance = maxDistance;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectPlace(MapPlace? place) {
    if (_selectedPlace?.id == place?.id) {
      _selectedPlace = null;
    } else {
      _selectedPlace = place;
    }
    notifyListeners();
  }

  List<MapCategory> _categories = [];
  List<MapCategory> get categoriesList => _categories;

  @override
  Future<Result<List<MapPlace>>> getData(void param) async {
    final categoriesResult = await _mapInteractor.getCategories();
    if (categoriesResult is Ok<List<MapCategory>>) {
      _categories = categoriesResult.value;
      notifyListeners();
    }
    return _mapInteractor.getPlaces();
  }
}
