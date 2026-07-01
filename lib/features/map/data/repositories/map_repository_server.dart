import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:travel_map/features/map/data/repositories/map_repository.dart';
import 'package:travel_map/features/map/domain/models/map_category.dart';
import 'package:travel_map/features/map/domain/models/map_place.dart';
import 'package:travel_map/shared/result.dart';

class MapServerRepositoryImpl implements MapServerRepository {
  MapServerRepositoryImpl(this._log, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _apiBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
              headers: const {'Accept': 'application/json'},
            ),
          );

  static final String _apiBaseUrl = () {
    const envUrl = String.fromEnvironment('TRAVEL_SOCIAL_API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000/api/v1';
      }
    } catch (_) {
      // Fallback if Platform is not supported (e.g. Web)
    }
    return 'http://127.0.0.1:3000/api/v1';
  }();

  final Logger _log;
  final Dio _dio;

  Uri get _apiBaseUri => Uri.parse(_apiBaseUrl);

  @override
  Future<Result<List<MapPlace>>> getPlaces() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/areas/tien-thang/places',
      );
      final payload = response.data?['data'];
      final rows = payload is List ? payload : const <dynamic>[];
      final places = rows
          .whereType<Map<String, dynamic>>()
          .map(_mapPlace)
          .where((place) => place.latitude != 0 && place.longitude != 0)
          .toList(growable: false);

      return Ok(places);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load map places', error, stackTrace);
      return Error(error, stackTrace);
    }
  }

  @override
  Future<Result<List<MapCategory>>> getCategories() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/place-categories',
      );
      final payload = response.data?['data'];
      final rows = payload is List ? payload : const <dynamic>[];
      final categories = rows
          .whereType<Map<String, dynamic>>()
          .map(_mapCategory)
          .toList(growable: false);

      return Ok(categories);
    } on Object catch (error, stackTrace) {
      _log.warning('Failed to load map categories', error, stackTrace);
      return Error(error, stackTrace);
    }
  }

  MapCategory _mapCategory(Map<String, dynamic> json) {
    return MapCategory(
      id: _asString(json['id']) ?? '',
      name: _asString(json['name']) ?? 'Chưa phân loại',
      code: _asString(json['code']),
      description: _asString(json['description']),
      icon: _asString(json['icon']),
      iconUrl: _resolveMediaUrl(_asString(json['iconUrl'])),
      markerColor: _asString(json['markerColor']),
    );
  }

  MapPlace _mapPlace(Map<String, dynamic> json) {
    final category = _asMap(json['category']);
    final placeMarkerIcon = _asMap(json['markerIcon']);
    final categoryMarkerIcon = _asMap(category?['markerIcon']);
    final markerIcon = placeMarkerIcon ?? categoryMarkerIcon;
    final images = _asList(json['images']);
    final firstImage = images.isNotEmpty ? _asMap(images.first) : null;
    final coverUrl = _resolveMediaUrl(_asString(json['coverUrl']));
    final imageUrl =
        coverUrl ?? _resolveMediaUrl(_asString(firstImage?['imageUrl'])) ?? '';

    final mediaItems = <MapMediaItem>[
      if (imageUrl.isNotEmpty) MapMediaItem(url: imageUrl),
      ...images
          .whereType<Map<String, dynamic>>()
          .map((image) => _resolveMediaUrl(_asString(image['imageUrl'])))
          .whereType<String>()
          .where((url) => url != imageUrl)
          .map((url) => MapMediaItem(url: url)),
      if (_resolveMediaUrl(_asString(json['videoUrl'])) case final videoUrl?)
        MapMediaItem(
          url: imageUrl,
          thumbnailUrl: imageUrl,
          isVideo: true,
          videoUrl: videoUrl,
        ),
    ];

    final mediaUrls = mediaItems
        .map((item) => item.isVideo ? item.thumbnailUrl ?? item.url : item.url)
        .where((url) => url.isNotEmpty)
        .toList(growable: false);

    return MapPlace(
      id: _asString(json['id']) ?? '',
      title: _asString(json['name']) ?? '',
      category: _asString(category?['name']) ?? 'Chưa phân loại',
      address: _asString(json['address']) ?? '',
      distance: '',
      distanceKm: 0,
      imageUrl: imageUrl,
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      description:
          _asString(json['description']) ?? _asString(json['summary']) ?? '',
      mediaUrls: mediaUrls,
      mediaItems: mediaItems,
      views: _formatCount(_asInt(json['postCount'])),
      rating: _asDouble(json['ratingAvg']),
      reviewCount: _asInt(json['ratingCount']),
      openHours: _asString(json['bestTime']) ?? '',
      markerIconKey:
          _asString(markerIcon?['key']) ?? _asString(category?['icon']),
      markerIconUrl:
          _resolveMediaUrl(_asString(markerIcon?['iconUrl'])) ??
          _resolveMediaUrl(_asString(category?['iconUrl'])),
      markerColor:
          _asString(markerIcon?['markerColor']) ??
          _asString(category?['markerColor']),
    );
  }

  String? _resolveMediaUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri != null && uri.hasScheme) {
      if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
        return uri
            .replace(host: _apiBaseUri.host, port: _apiBaseUri.port)
            .toString();
      }
      return url;
    }
    final origin = _apiBaseUri.replace(path: '', query: '', fragment: '');
    if (url.startsWith('/')) {
      return origin.resolve(url).toString();
    }
    return origin.resolve('/$url').toString();
  }

  Map<String, dynamic>? _asMap(Object? value) {
    return value is Map<String, dynamic> ? value : null;
  }

  List<dynamic> _asList(Object? value) {
    return value is List ? value : const [];
  }

  String? _asString(Object? value) {
    if (value == null) return null;
    final stringValue = value.toString();
    return stringValue.isEmpty ? null : stringValue;
  }

  double _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _asInt(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatCount(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toString();
  }
}
