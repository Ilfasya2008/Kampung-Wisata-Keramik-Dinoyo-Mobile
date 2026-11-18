import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    super.price,
    required super.imageAsset,
    super.shopId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'imageAsset': imageAsset,
        'shopId': shopId,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        price: json['price'],
        imageAsset: json['imageAsset'] ?? 'assets/images/product_vas_bunga.jpg',
        shopId: json['shopId'],
      );

  Product toDomain() => Product(
        id: id,
        name: name,
        description: description,
        category: category,
        price: price,
        imageAsset: imageAsset,
        shopId: shopId,
      );
}
