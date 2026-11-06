// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'SneakHub';

  @override
  String get welcome => 'Bienvenido a SneakHub';

  @override
  String get loginSubtitle => 'Ingresa tus credenciales para continuar';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get emailRequired => 'El correo es obligatorio';

  @override
  String get emailInvalid => 'Ingresa un correo válido';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get passwordMin => 'Mínimo 4 caracteres';

  @override
  String get completeFields => 'Por favor completa todos los campos';

  @override
  String get noAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get haveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Regístrate para comprar tus tenis favoritos';

  @override
  String get register => 'Registrarme';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get home => 'Inicio';

  @override
  String get sneakers => 'Tenis';

  @override
  String get sneaker => 'Tenis';

  @override
  String get catalog => 'Catálogo';

  @override
  String get brands => 'Marcas';

  @override
  String get brand => 'Marca';

  @override
  String get categories => 'Categorías';

  @override
  String get category => 'Categoría';

  @override
  String get orders => 'Pedidos';

  @override
  String get myOrders => 'Mis pedidos';

  @override
  String get cart => 'Carrito';

  @override
  String get profile => 'Perfil';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get settings => 'Preferencias';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleCustomer => 'Cliente';

  @override
  String hello(String name) {
    return 'Hola, $name';
  }

  @override
  String get dashboardSubtitle => 'Este es el resumen de tu tienda';

  @override
  String get customerSubtitle => 'Encuentra tu próximo par de tenis';

  @override
  String get lowStock => 'Stock bajo';

  @override
  String get lowStockTitle => 'Stock bajo (5 o menos)';

  @override
  String get stockOk => 'Todo el catálogo tiene stock suficiente';

  @override
  String get pendingOrders => 'Pedidos pendientes';

  @override
  String get sales => 'Ventas';

  @override
  String get recentOrders => 'Pedidos recientes';

  @override
  String get newArrivals => 'Novedades';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get goToCatalog => 'Ver catálogo';

  @override
  String get searchSneakers => 'Buscar tenis por nombre';

  @override
  String get all => 'Todas';

  @override
  String get clearFilters => 'Quitar filtros';

  @override
  String get noSneakers => 'No hay tenis que coincidan';

  @override
  String get newSneaker => 'Nuevo tenis';

  @override
  String get editSneaker => 'Editar tenis';

  @override
  String get outOfStock => 'Agotado';

  @override
  String unitsLeft(int count) {
    return 'Quedan $count';
  }

  @override
  String inStock(int count) {
    return '$count disponibles';
  }

  @override
  String get sizes => 'Tallas';

  @override
  String get size => 'Talla';

  @override
  String get quantity => 'Cantidad';

  @override
  String get chooseSize => 'Elige una talla';

  @override
  String get addToCart => 'Agregar al carrito';

  @override
  String get addedToCart => 'Agregado al carrito';

  @override
  String get viewCart => 'Ver carrito';

  @override
  String alreadyInCart(int count) {
    return 'Ya tienes $count en el carrito';
  }

  @override
  String notEnoughStock(int count) {
    return 'No hay suficiente stock (disponibles: $count)';
  }

  @override
  String get genderMen => 'Hombre';

  @override
  String get genderWomen => 'Mujer';

  @override
  String get genderUnisex => 'Unisex';

  @override
  String get deleteSneaker => 'Eliminar tenis';

  @override
  String deleteSneakerConfirm(String name) {
    return '¿Seguro que quieres eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get sneakerDeleted => 'Tenis eliminado';

  @override
  String get sneakerSaved => 'Tenis guardado';

  @override
  String sneakerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tenis',
      one: '1 tenis',
      zero: 'Sin tenis',
    );
    return '$_temp0';
  }

  @override
  String get name => 'Nombre';

  @override
  String get price => 'Precio';

  @override
  String get stock => 'Stock';

  @override
  String get gender => 'Género';

  @override
  String get colors => 'Colores';

  @override
  String get colorsHint => 'Ej: Blanco, Negro';

  @override
  String get description => 'Descripción';

  @override
  String get images => 'Imágenes';

  @override
  String get imageUrl => 'URL de la imagen';

  @override
  String get addImage => 'Agregar';

  @override
  String get noImages =>
      'Sin imágenes. Agrega al menos una URL para que se vea en el catálogo.';

  @override
  String get sizesRequired => 'Elige al menos una talla';

  @override
  String get priceInvalid => 'Debe ser mayor a 0';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get optional => 'Opcional';

  @override
  String get logoUrl => 'URL del logo';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get retry => 'Reintentar';

  @override
  String get newBrand => 'Nueva marca';

  @override
  String get brandCreated => 'Marca creada';

  @override
  String get noBrands => 'Aún no hay marcas';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get categoryCreated => 'Categoría creada';

  @override
  String get noCategories => 'Aún no hay categorías';

  @override
  String orderNumber(int id) {
    return 'Pedido #$id';
  }

  @override
  String get noOrders => 'No hay pedidos';

  @override
  String get noOrdersCustomer => 'Todavía no has hecho ningún pedido';

  @override
  String unitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unidades',
      one: '1 unidad',
    );
    return '$_temp0';
  }

  @override
  String get products => 'Productos';

  @override
  String get total => 'Total';

  @override
  String get changeStatus => 'Cambiar estado';

  @override
  String statusUpdated(String status) {
    return 'Estado actualizado: $status';
  }

  @override
  String get cancelOrder => 'Cancelar pedido';

  @override
  String get cancelOrderConfirm =>
      'Al cancelar, el stock vuelve al catálogo y el pedido ya no podrá cambiar de estado.';

  @override
  String get orderCancelledInfo =>
      'Este pedido está cancelado y ya no puede cambiar de estado.';

  @override
  String get orderCancelledNotice =>
      'Pedido cancelado. El stock fue devuelto al catálogo.';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusPaid => 'Pagado';

  @override
  String get statusShipped => 'Enviado';

  @override
  String get statusDelivered => 'Entregado';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get cartEmpty => 'Tu carrito está vacío';

  @override
  String get checkout => 'Finalizar compra';

  @override
  String get orderCreated => '¡Pedido creado!';

  @override
  String get errorUnauthorized =>
      'Tu sesión no es válida. Vuelve a iniciar sesión.';

  @override
  String get errorForbidden => 'No tienes permiso para hacer esto.';

  @override
  String errorServer(int status) {
    return 'Error del servidor: $status';
  }

  @override
  String get errorTimeout => 'Tiempo de conexión agotado.';

  @override
  String get errorNetwork => 'No se pudo conectar con la API. ¿Está encendida?';

  @override
  String get errorUnexpected => 'Ocurrió un error inesperado.';

  @override
  String get heroTag => 'Nueva temporada';

  @override
  String get heroTitle => 'ENCUENTRA\nTU PRÓXIMO\nPAR.';

  @override
  String get heroSubtitle =>
      'Las mejores marcas de tenis en un solo lugar: running, basketball, skate y lifestyle.';

  @override
  String get heroBrands =>
      'NIKE · ADIDAS · PUMA · NEW BALANCE · CONVERSE · VANS';

  @override
  String get adminTag => 'Panel de administración';
}
