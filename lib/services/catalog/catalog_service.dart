import 'package:pacial_2/config/api/api_client.dart';
import 'package:pacial_2/config/api/api_config.dart';
import 'package:pacial_2/model/catalog/catalog_model.dart';

/// Marcas y categorías.
class CatalogService {
  static Future<List<Brand>> brands() async {
    final response = await ApiClient.dio.get(ApiConfig.brands);
    return (response.data as List)
        .map((e) => Brand.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Brand> createBrand(String name, String? logo) async {
    final response = await ApiClient.dio.post(
      ApiConfig.brands,
      data: {'name': name, 'logo': logo},
    );
    return Brand.fromJson(response.data);
  }

  static Future<List<Category>> categories() async {
    final response = await ApiClient.dio.get(ApiConfig.categories);
    return (response.data as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Category> createCategory(String name) async {
    final response = await ApiClient.dio.post(
      ApiConfig.categories,
      data: {'name': name},
    );
    return Category.fromJson(response.data);
  }
}
