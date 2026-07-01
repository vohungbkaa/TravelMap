class ShopProduct {
  final String id;
  final String name;
  final String price;
  final String origin;
  final String rating;
  final String imageUrl;
  final String category;
  final String description;
  final bool isOcop;

  const ShopProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.origin,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.isOcop = true,
  });
}
