class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? price;
  final String imageAsset;
  final String? shopId;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.price,
    required this.imageAsset,
    this.shopId,
  });
}
