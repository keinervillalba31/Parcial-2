import 'package:pacial_2/config/api/api_client.dart';
import 'package:pacial_2/config/api/api_config.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';

class SneakerService {
  static Future<List<Sneaker>> findAll([
    SneakerFilter filter = const SneakerFilter(),
  ]) async {
    final response = await ApiClient.dio.get(
      ApiConfig.sneakers,
      queryParameters: filter.toQuery(),
    );
    return (response.data as List)
        .map((e) => Sneaker.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Sneaker> findById(int id) async {
    final response = await ApiClient.dio.get('${ApiConfig.sneakers}/$id');
    return Sneaker.fromJson(response.data);
  }

  /// [data] tiene la forma de `SneakerRequest` en la API.
  static Future<Sneaker> create(Map<String, dynamic> data) async {
    final response = await ApiClient.dio.post(ApiConfig.sneakers, data: data);
    return Sneaker.fromJson(response.data);
  }

  static Future<Sneaker> update(int id, Map<String, dynamic> data) async {
    final response = await ApiClient.dio.put(
      '${ApiConfig.sneakers}/$id',
      data: data,
    );
    return Sneaker.fromJson(response.data);
  }

  static Future<void> delete(int id) async {
    await ApiClient.dio.delete('${ApiConfig.sneakers}/$id');
  }
}
