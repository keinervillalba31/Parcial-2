import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pacial_2/model/order/order_model.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';
import 'package:pacial_2/providers/cart_provider.dart';

/// Mismo formato JSON que devuelve la API.
Map<String, dynamic> sneakerJson({int id = 1, int stock = 3}) => {
  'id': id,
  'name': 'Nike Air Max 90',
  'description': 'Clásico',
  'price': 649900.0,
  'stock': stock,
  'gender': 'UNISEX',
  'colors': 'Blanco',
  'sizes': [38, 39, 40],
  'images': ['https://placehold.co/600x400.png'],
  'brand': {'id': 1, 'name': 'Nike', 'logo': null},
  'category': {'id': 3, 'name': 'Lifestyle'},
};

void main() {
  group('Modelos', () {
    test('Sneaker.fromJson lee marca, categoría y listas', () {
      final s = Sneaker.fromJson(sneakerJson());
      expect(s.brand.name, 'Nike');
      expect(s.category.id, 3);
      expect(s.sizes, [38, 39, 40]);
      expect(s.mainImage, isNotNull);
      expect(s.isLowStock, isTrue);
    });

    test('Order.fromJson lee items y fecha sin zona horaria', () {
      final order = Order.fromJson({
        'id': 7,
        'user': {
          'id': 2,
          'name': 'Cliente Demo',
          'email': 'cliente@sneakhub.com',
          'role': 'CUSTOMER',
          'avatar': null,
        },
        'items': [
          {
            'id': 1,
            'sneakerId': 1,
            'sneakerName': 'Nike Air Max 90',
            'image': null,
            'size': 40,
            'quantity': 2,
            'unitPrice': 100.0,
            'subtotal': 200.0,
          },
        ],
        'total': 200,
        'status': 'PENDIENTE',
        'createdAt': '2026-11-06T10:15:30.123456',
      });
      expect(order.unitCount, 2);
      expect(order.total, 200.0);
      expect(order.user.isAdmin, isFalse);
      expect(order.createdAt.day, 6);
    });

    test('SneakerFilter solo manda los filtros usados', () {
      expect(const SneakerFilter().toQuery(), isEmpty);
      expect(const SneakerFilter(query: 'air', brandId: 1).toQuery(), {
        'q': 'air',
        'brandId': 1,
      });
    });
  });

  group('Carrito', () {
    late ProviderContainer container;
    late CartNotifier cart;
    final sneaker = Sneaker.fromJson(sneakerJson(stock: 3));

    setUp(() {
      container = ProviderContainer();
      cart = container.read(cartProvider.notifier);
    });
    tearDown(() => container.dispose());

    test('suma la misma talla en una sola línea', () {
      cart.add(sneaker, 40, 1);
      cart.add(sneaker, 40, 1);
      expect(container.read(cartProvider), hasLength(1));
      expect(cart.unitCount, 2);
      expect(cart.total, sneaker.price * 2);
    });

    test('valida el stock sumando todas las tallas del tenis', () {
      expect(cart.add(sneaker, 39, 2), isTrue);
      expect(cart.add(sneaker, 40, 2), isFalse);
      expect(cart.add(sneaker, 40, 1), isTrue);
      expect(cart.unitCount, 3);
    });

    test('setQuantity respeta el máximo y remove quita la línea', () {
      cart.add(sneaker, 39, 1);
      cart.add(sneaker, 40, 1);
      final line = container.read(cartProvider).first;
      expect(cart.maxQuantityFor(line), 2);

      cart.setQuantity(line, 3);
      expect(cart.unitCount, 2);

      cart.remove(line);
      expect(container.read(cartProvider), hasLength(1));
    });
  });
}
