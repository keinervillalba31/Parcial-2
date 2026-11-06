import 'package:pacial_2/model/catalog/catalog_model.dart';

class Sneaker {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String gender;
  final String? colors;
  final List<int> sizes;
  final List<String> images;
  final Brand brand;
  final Category category;

  const Sneaker({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.gender,
    this.colors,
    required this.sizes,
    required this.images,
    required this.brand,
    required this.category,
  });

  String? get mainImage => images.isEmpty ? null : images.first;

  bool get isOutOfStock => stock <= 0;

  /// Umbral para avisar "quedan pocas unidades".
  bool get isLowStock => stock > 0 && stock <= 5;

  factory Sneaker.fromJson(Map<String, dynamic> json) {
    return Sneaker(
      id: json['id'] as int,
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      gender: json['gender'] ?? 'UNISEX',
      colors: json['colors'],
      sizes: List<int>.from(json['sizes'] ?? const []),
      images: List<String>.from(json['images'] ?? const []),
      brand: Brand.fromJson(json['brand']),
      category: Category.fromJson(json['category']),
    );
  }
}

/// Filtros opcionales de `GET /sneakers`.
class SneakerFilter {
  final String query;
  final int? brandId;
  final int? categoryId;
  final String? gender;

  const SneakerFilter({
    this.query = '',
    this.brandId,
    this.categoryId,
    this.gender,
  });

  bool get isActive =>
      query.isNotEmpty ||
      brandId != null ||
      categoryId != null ||
      gender != null;

  Map<String, dynamic> toQuery() => {
    if (query.isNotEmpty) 'q': query,
    'brandId': ?brandId,
    'categoryId': ?categoryId,
    'gender': ?gender,
  };
}
