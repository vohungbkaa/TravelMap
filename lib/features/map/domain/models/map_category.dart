class MapCategory {
  const MapCategory({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.icon,
    this.iconUrl,
    this.markerColor,
  });

  final String id;
  final String name;
  final String? code;
  final String? description;
  final String? icon;
  final String? iconUrl;
  final String? markerColor;
}
