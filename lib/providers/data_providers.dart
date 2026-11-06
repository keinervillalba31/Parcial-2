import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/model/catalog/catalog_model.dart';
import 'package:pacial_2/model/order/order_model.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';
import 'package:pacial_2/model/user/user_model.dart';
import 'package:pacial_2/services/auth/auth_service.dart';
import 'package:pacial_2/services/catalog/catalog_service.dart';
import 'package:pacial_2/services/orders/order_service.dart';
import 'package:pacial_2/services/sneakers/sneaker_service.dart';

// Los providers con autoDispose se liberan cuando nadie los usa, así que al
// cerrar sesión y entrar con otro usuario se vuelven a pedir a la API.

/// Usuario logueado. El layout lo mantiene vivo mientras haya sesión.
final profileProvider = FutureProvider.autoDispose<UserModel>(
  (ref) => AuthService.profile(),
);

final brandsProvider = FutureProvider.autoDispose<List<Brand>>(
  (ref) => CatalogService.brands(),
);

final categoriesProvider = FutureProvider.autoDispose<List<Category>>(
  (ref) => CatalogService.categories(),
);

// ----- Tenis -----

final sneakerFilterProvider =
    NotifierProvider<SneakerFilterNotifier, SneakerFilter>(
      SneakerFilterNotifier.new,
    );

class SneakerFilterNotifier extends Notifier<SneakerFilter> {
  @override
  SneakerFilter build() => const SneakerFilter();

  void setQuery(String query) => state = SneakerFilter(
    query: query.trim(),
    brandId: state.brandId,
    categoryId: state.categoryId,
    gender: state.gender,
  );

  void setBrand(int? brandId) => state = SneakerFilter(
    query: state.query,
    brandId: brandId,
    categoryId: state.categoryId,
    gender: state.gender,
  );

  void setCategory(int? categoryId) => state = SneakerFilter(
    query: state.query,
    brandId: state.brandId,
    categoryId: categoryId,
    gender: state.gender,
  );

  void setGender(String? gender) => state = SneakerFilter(
    query: state.query,
    brandId: state.brandId,
    categoryId: state.categoryId,
    gender: gender,
  );

  void clear() => state = const SneakerFilter();
}

/// Catálogo con los filtros aplicados (se recarga al cambiar un filtro).
final sneakersProvider = FutureProvider.autoDispose<List<Sneaker>>(
  (ref) => SneakerService.findAll(ref.watch(sneakerFilterProvider)),
);

/// Catálogo completo, para el inicio.
final allSneakersProvider = FutureProvider.autoDispose<List<Sneaker>>(
  (ref) => SneakerService.findAll(),
);

final sneakerProvider = FutureProvider.autoDispose.family<Sneaker, int>(
  (ref, id) => SneakerService.findById(id),
);

// ----- Pedidos -----

final ordersProvider = FutureProvider.autoDispose<List<Order>>(
  (ref) => OrderService.findAll(),
);

final orderProvider = FutureProvider.autoDispose.family<Order, int>(
  (ref, id) => OrderService.findById(id),
);

/// Recarga las listas de tenis tras crear, editar, borrar o vender.
void invalidateSneakerLists(WidgetRef ref) {
  ref.invalidate(sneakersProvider);
  ref.invalidate(allSneakersProvider);
}
