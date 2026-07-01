class MapMediaItem {
  const MapMediaItem({
    required this.url,
    this.thumbnailUrl,
    this.isVideo = false,
    this.videoUrl,
  });

  final String url;
  final String? thumbnailUrl;
  final bool isVideo;
  final String? videoUrl;
}

class MapPlace {
  const MapPlace({
    required this.id,
    required this.title,
    required this.category,
    required this.address,
    required this.distance,
    required this.distanceKm,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.mediaUrls,
    required this.mediaItems,
    required this.views,
    required this.rating,
    required this.reviewCount,
    required this.openHours,
    this.markerIconKey,
    this.markerIconUrl,
    this.markerColor,
  });

  final String id;
  final String title;
  final String category;
  final String address;
  final String distance;
  final double distanceKm;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String description;
  final List<String> mediaUrls;
  final List<MapMediaItem> mediaItems;
  final String views;
  final double rating;
  final int reviewCount;
  final String openHours;
  final String? markerIconKey;
  final String? markerIconUrl;
  final String? markerColor;
}
