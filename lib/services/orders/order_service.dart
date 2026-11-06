import 'package:pacial_2/config/api/api_client.dart';
import 'package:pacial_2/config/api/api_config.dart';
import 'package:pacial_2/model/order/order_model.dart';
import 'package:pacial_2/providers/cart_provider.dart';

class OrderService {
  /// El cliente ve sus pedidos; el ADMIN ve todos (lo decide la API).
  static Future<List<Order>> findAll() async {
    final response = await ApiClient.dio.get(ApiConfig.orders);
    return (response.data as List)
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Order> findById(int id) async {
    final response = await ApiClient.dio.get('${ApiConfig.orders}/$id');
    return Order.fromJson(response.data);
  }

  static Future<Order> create(List<CartItem> items) async {
    final response = await ApiClient.dio.post(
      ApiConfig.orders,
      data: {
        'items': [
          for (final item in items)
            {
              'sneakerId': item.sneaker.id,
              'size': item.size,
              'quantity': item.quantity,
            },
        ],
      },
    );
    return Order.fromJson(response.data);
  }

  static Future<Order> updateStatus(int id, String status) async {
    final response = await ApiClient.dio.patch(
      '${ApiConfig.orders}/$id/status',
      data: {'status': status},
    );
    return Order.fromJson(response.data);
  }
}
