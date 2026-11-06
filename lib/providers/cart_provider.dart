import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';

class CartItem {
  final Sneaker sneaker;
  final int size;
  final int quantity;

  const CartItem({
    required this.sneaker,
    required this.size,
    required this.quantity,
  });

  double get subtotal => sneaker.price * quantity;

  bool sameAs(int sneakerId, int size) =>
      sneaker.id == sneakerId && this.size == size;
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

/// Carrito en memoria. El stock se valida contra el total del tenis
/// (sumando todas sus tallas), igual que hace la API al crear el pedido.
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => const [];

  int get unitCount => state.fold(0, (sum, item) => sum + item.quantity);

  double get total => state.fold(0, (sum, item) => sum + item.subtotal);

  int quantityOf(int sneakerId) => state
      .where((item) => item.sneaker.id == sneakerId)
      .fold(0, (sum, item) => sum + item.quantity);

  /// Devuelve `false` si con esa cantidad se supera el stock.
  bool add(Sneaker sneaker, int size, int quantity) {
    if (quantityOf(sneaker.id) + quantity > sneaker.stock) return false;

    final index = state.indexWhere((item) => item.sameAs(sneaker.id, size));
    if (index < 0) {
      state = [
        ...state,
        CartItem(sneaker: sneaker, size: size, quantity: quantity),
      ];
    } else {
      final current = state[index];
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index)
            CartItem(
              sneaker: sneaker,
              size: size,
              quantity: current.quantity + quantity,
            )
          else
            state[i],
      ];
    }
    return true;
  }

  /// Máximo que se puede poner en esta línea sin pasar el stock.
  int maxQuantityFor(CartItem item) =>
      item.sneaker.stock - quantityOf(item.sneaker.id) + item.quantity;

  void setQuantity(CartItem item, int quantity) {
    if (quantity < 1 || quantity > maxQuantityFor(item)) return;
    state = [
      for (final current in state)
        if (current.sameAs(item.sneaker.id, item.size))
          CartItem(sneaker: item.sneaker, size: item.size, quantity: quantity)
        else
          current,
    ];
  }

  void remove(CartItem item) {
    state = state
        .where((current) => !current.sameAs(item.sneaker.id, item.size))
        .toList();
  }

  void clear() => state = const [];
}
