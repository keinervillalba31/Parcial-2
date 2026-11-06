import 'package:pacial_2/model/user/user_model.dart';

class OrderItem {
  final int id;
  final int sneakerId;
  final String sneakerName;
  final String? image;
  final int size;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItem({
    required this.id,
    required this.sneakerId,
    required this.sneakerName,
    this.image,
    required this.size,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      sneakerId: json['sneakerId'] as int,
      sneakerName: json['sneakerName'] ?? '',
      image: json['image'],
      size: json['size'] as int,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

class Order {
  final int id;
  final UserModel user;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.user,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  int get unitCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      user: UserModel.fromJson(json['user']),
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] ?? 'PENDIENTE',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
